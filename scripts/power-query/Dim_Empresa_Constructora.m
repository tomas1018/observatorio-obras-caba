let
    // 1. Conexión y selección de columnas útiles
    Origen = Excel.Workbook(File.Contents("C:\Users\W10-PC\Downloads\Observatorio de Obras Urbanas en CABA.xlsx"), null, true),
    EMPRESA_Sheet = Origen{[Item="EMPRESA CONSTRUCTORA",Kind="Sheet"]}[Data],
    
    // Eliminamos columnas vacías del Excel antes de procesar (de la 5 en adelante)
    Columnas_Interes = Table.SelectColumns(EMPRESA_Sheet, {"Column1", "Column2"}),
    Encabezados_Promovidos = Table.PromoteHeaders(Columnas_Interes, [PromoteAllScalars=true]),
    
    // 2. Tipado y limpieza de filas nulas
    Definicion_Tipos = Table.TransformColumnTypes(Encabezados_Promovidos,{{"ID", Int64.Type}, {"NOMBRE", type text}}),
    Filas_Vacias_Quitadas = Table.SelectRows(Definicion_Tipos, each ([ID] <> null)),

    // 3. Normalización de Nombres (Limpieza de Strings)
    // Corregimos casos específicos de puntuación y errores de codificación
    Arreglar_Ponce = Table.ReplaceValue(Filas_Vacias_Quitadas, "A.E. Ponce Ingenieria Sa", "A.E. Ponce Ingenieria S.A.", Replacer.ReplaceText, {"NOMBRE"}),
    Arreglar_Algieri = Table.ReplaceValue(Arreglar_Ponce, "Algieri", "Algieri S.A.", Replacer.ReplaceText, {"NOMBRE"}),
    Limpiar_Algieri_Doble = Table.ReplaceValue(Arreglar_Algieri, "S.A. S.A.", "S.A.", Replacer.ReplaceText, {"NOMBRE"}),
    
    // Consolidación de "Altote - Naku" (Maneja múltiples variantes y caracteres especiales en un solo paso)
    Normalizar_Altote = Table.ReplaceValue(Limpiar_Algieri_Doble, each [NOMBRE], each 
        if Text.Contains([NOMBRE], "Altote", Appearance.IgnoreCase) then "Altote S.A. - Naku Construcciones S.R.L. - (Ute)" 
        else [NOMBRE], Replacer.ReplaceValue, {"NOMBRE"}),

    // 4. Normalización de IDs (Corrección de claves primarias)
    Corregir_IDs = Table.ReplaceValue(Normalizar_Altote, each [ID], each 
        if [ID] = 299 then 144 
        else if [ID] = 287 then 126 
        else if List.Contains({25, 250, 279, 281, 288}, [ID]) then 2 
        else [ID], Replacer.ReplaceValue, {"ID"}),

    // 5. Consolidación Final
    // Quitamos duplicados una sola vez después de haber normalizado nombres e IDs
    Duplicados_Quitados = Table.Distinct(Corregir_IDs, {"ID"})
in
    Duplicados_Quitados