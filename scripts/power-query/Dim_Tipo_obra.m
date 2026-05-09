let
    // 1. Conexión y selección de columnas de interés (ID y Nombre del Tipo de Obra)
    Origen = Excel.Workbook(File.Contents("C:\Users\W10-PC\Downloads\Observatorio de Obras Urbanas en CABA.xlsx"), null, true),
    TIPO_OBRA_Sheet = Origen{[Item="TIPO OBRA",Kind="Sheet"]}[Data],
    
    // Seleccionamos solo las primeras 2 columnas para ignorar las columnas vacías a la derecha
    Columnas_Interes = Table.SelectColumns(TIPO_OBRA_Sheet, {"Column1", "Column2"}),
    
    // 2. Definición de estructura
    Encabezados_Promovidos = Table.PromoteHeaders(Columnas_Interes, [PromoteAllScalars=true]),
    
    // 3. Tipado y limpieza de registros nulos
    Definicion_Tipos = Table.TransformColumnTypes(Encabezados_Promovidos,{
        {"ID", Int64.Type}, 
        {"NOMBRE", type text}
    }),
    
    // Filtramos filas que no contengan un ID válido
    Filas_Nulas_Quitadas = Table.SelectRows(Definicion_Tipos, each ([ID] <> null))
in
    Filas_Nulas_Quitadas