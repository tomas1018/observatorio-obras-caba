let
    // 1. Conexión y selección de columnas necesarias (ID, Nombre, Público/Privado)
    // Filtramos las columnas desde el inicio para ignorar el ruido del Excel
    Origen = Excel.Workbook(File.Contents("C:\Users\W10-PC\Downloads\Observatorio de Obras Urbanas en CABA.xlsx"), null, true),
    TIPO_CONTRATACION_Sheet = Origen{[Item="TIPO CONTRATACION",Kind="Sheet"]}[Data],
    Columnas_Interes = Table.SelectColumns(TIPO_CONTRATACION_Sheet, {"Column1", "Column2", "Column3"}),
    
    // 2. Definición de estructura
    Encabezados_Promovidos = Table.PromoteHeaders(Columnas_Interes, [PromoteAllScalars=true]),
    
    // 3. Tipado de datos y limpieza de nulos
    // Aseguramos que el ID sea entero para la relación con la tabla de hechos (Fact Table)
    Definicion_Tipos = Table.TransformColumnTypes(Encabezados_Promovidos,{
        {"ID", Int64.Type}, 
        {"NOMBRE", type text}, 
        {"PUBLICO/PRIVADO", type text}
    }),
    
    // Filtramos filas vacías basándonos en la existencia de un ID
    Filas_Nulas_Quitadas = Table.SelectRows(Definicion_Tipos, each ([ID] <> null))
in
    Filas_Nulas_Quitadas