let
    // 1. Conexión y selección de columnas útiles
    Origen = Excel.Workbook(File.Contents("C:\Users\W10-PC\Downloads\Observatorio de Obras Urbanas en CABA.xlsx"), null, true),
    BARRIOS_Sheet = Origen{[Item="BARRIOS",Kind="Sheet"]}[Data],
    
    // Filtramos solo las primeras 3 columnas para ignorar el ruido del archivo
    Columnas_Interes = Table.SelectColumns(BARRIOS_Sheet, {"Column1", "Column2", "Column3"}),
    Encabezados_Promovidos = Table.PromoteHeaders(Columnas_Interes, [PromoteAllScalars=true]),
    
    // 2. Tipado de datos inicial
    Definicion_Tipos = Table.TransformColumnTypes(Encabezados_Promovidos,{
        {"ID", Int64.Type}, 
        {"BARRIO", type text}, 
        {"COMUNA", Int64.Type}
    }),

    // 3. Limpieza de filas nulas y normalización de IDs
    Filas_Vacias_Quitadas = Table.SelectRows(Definicion_Tipos, each ([ID] <> null)),
    
    // Corrección de IDs inconsistentes
    Corregir_IDs = Table.ReplaceValue(Filas_Vacias_Quitadas, each [ID], each 
        if [ID] = 16 then 11 
        else if [ID] = 50 then 13 
        else if [ID] = 47 then 9 
        else [ID], Replacer.ReplaceValue, {"ID"}),

    // 4. Normalización de nombres de barrios (Ortografía y Tildes)
    Corregir_Constitucion = Table.ReplaceValue(Corregir_IDs, "Constitucion", "Constitución", Replacer.ReplaceText, {"BARRIO"}),
    Corregir_VillaOrtuzar = Table.ReplaceValue(Corregir_Constitucion, "Villa Ortuzar", "Villa Ortúzar", Replacer.ReplaceText, {"BARRIO"}),
    Corregir_Montserrat = Table.ReplaceValue(Corregir_VillaOrtuzar, "Monserrat", "Montserrat", Replacer.ReplaceText, {"BARRIO"}),

    // 5. Consolidación final
    // Eliminamos duplicados por ID para asegurar la integridad de la dimensión
    Duplicados_Quitados = Table.Distinct(Corregir_Montserrat, {"ID"}),
    
    // Reordenamos columnas para una mejor visualización (opcional)
    Resultado_Final = Table.ReorderColumns(Duplicados_Quitados, {"ID", "BARRIO", "COMUNA"})
in
    Resultado_Final