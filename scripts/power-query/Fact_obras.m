let
    // 1. Conexión al origen de datos
    Origen = Excel.Workbook(File.Contents("C:\Users\W10-PC\Downloads\Observatorio de Obras Urbanas en CABA.xlsx"), null, true),
    OBRAS_Sheet = Origen{[Item="OBRAS",Kind="Sheet"]}[Data],

    // 2. Preparación de encabezados y limpieza de filas vacías iniciales
    FilasEnBlanco_Eliminadas = Table.SelectRows(OBRAS_Sheet, each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null}))),
    Encabezados_Promovidos = Table.PromoteHeaders(FilasEnBlanco_Eliminadas, [PromoteAllScalars=true]),
    
    // 3. Tipado inicial de datos clave
    Definicion_Tipos = Table.TransformColumnTypes(Encabezados_Promovidos,{
        {"ID", Int64.Type}, {"Etapa", type text}, {"Monto Contrato", Int64.Type}, 
        {"ID Comuna", Int64.Type}, {"ID Barrio", Int64.Type}, {"Latitud", type number}, 
        {"Longitud", type number}, {"Fecha Inicio", type date}, {"Fecha Fin Inicial", type date}, 
        {"Plazo Meses", Int64.Type}, {"Avance", type number}, {"ID Constructora", Int64.Type}, 
        {"Mano de Obra", Int64.Type}, {"Beneficiarios", type any}
    }),

    // 4. Limpieza de columnas innecesarias (Optimización de memoria)
    Columnas_Quitadas = Table.RemoveColumns(Definicion_Tipos, {
        "Entorno", "Dirección", "Imagen 1", "Imagen 2", "Imagen 3", "Imagen 4", 
        "CUIT Contratista", "Compromiso", "Destacada", "BA Elige", "Link Interno", 
        "Pliego Descarga", "Expediente", "Estudio Ambiental", "Financiamiento", "Descripción"
    }),

    // 5. Normalización de IDs de Barrio y Constructora
    Corregir_Barrios = Table.ReplaceValue(Columnas_Quitadas, each [ID Barrio], each if [ID Barrio] = 16 then 11 else if [ID Barrio] = 50 then 13 else if [ID Barrio] = 47 then 9 else [ID Barrio], Replacer.ReplaceValue, {"ID Barrio"}),
    
    Corregir_Constructoras = Table.ReplaceValue(Corregir_Barrios, each [ID Constructora], each 
        if [ID Constructora] = 299 then 144 
        else if List.Contains({250, 279, 281, 288}, [ID Constructora]) then 2 
        else if [ID Constructora] = 287 then 126 
        else [ID Constructora], Replacer.ReplaceValue, {"ID Constructora"}),

    // 6. Normalización de texto en Etapa
    Corregir_Etapa = Table.ReplaceValue(Corregir_Constructoras, "FInalizada", "Finalizada", Replacer.ReplaceText, {"Etapa"}),
    Estandarizar_Ejecucion = Table.ReplaceValue(Corregir_Etapa, "En obra", "En ejecución", Replacer.ReplaceText, {"Etapa"}),
    Limpiar_Ejecucion_Variante = Table.ReplaceValue(Estandarizar_Ejecucion, "En ejecucion", "En ejecución", Replacer.ReplaceText, {"Etapa"}),

    // 7. Gestión de errores y valores nulos
    Errores_ManoObra = Table.RemoveRowsWithErrors(Limpiar_Ejecucion_Variante, {"Mano de Obra"}),
    Limpiar_Beneficiarios = Table.ReplaceValue(Errores_ManoObra, each [Beneficiarios], each if [Beneficiarios] = 0 or [Beneficiarios] = "usuarios" or [Beneficiarios] = "vecinos" then null else [Beneficiarios], Replacer.ReplaceValue, {"Beneficiarios"}),
    Tipo_Beneficiarios = Table.TransformColumnTypes(Limpiar_Beneficiarios, {{"Beneficiarios", type number}}),

    // 8. Lógica de Negocio: Clasificación de tamaño de obra
    Clasificacion_Obra = Table.AddColumn(Tipo_Beneficiarios, "Tamaño de obra", each 
        if [Mano de Obra] = null then "No existen datos" 
        else if [Mano de Obra] > 50 then "Obra grande" 
        else "Obra chica", type text)
in
    Clasificacion_Obra