\# Observatorio de Obras Urbanas en CABA



Este proyecto desarrolla una infraestructura analítica para la gestión estratégica de la obra pública en la Ciudad Autónoma de Buenos Aires. El sistema centraliza datos de ejecución para optimizar la distribución de recursos, prever plazos y evaluar el impacto económico en las diferentes comunas.



\## Objetivo del Análisis

El desarrollo busca proporcionar una visión integral sobre la inversión en infraestructura urbana. Se enfoca en identificar desviaciones en los plazos de ejecución, analizar la carga operativa por barrio y establecer indicadores de eficiencia que permitan mejorar la planificación presupuestaria del estado.



\## Tecnologías y Herramientas

\- Procesamiento y Visualización: Power BI

\- Motor de Consultas: Power Query (Lenguaje M) para procesos ETL complejos

\- Lógica de Negocio: Lenguaje DAX para el cálculo de KPIs y métricas de rendimiento

\- Diseño de Interfaz: Assets personalizados para optimizar la experiencia del usuario (UX)



\## Implementación Técnica (ETL y Modelado)

El flujo de trabajo se dividió en etapas críticas para garantizar la integridad de la información:

\- Normalización de Datos: Limpieza profunda de inconsistencias en registros geográficos y tratamiento de valores nulos para asegurar la precisión de los reportes.

\- Arquitectura de Datos: Implementación de un modelo relacional eficiente, con tablas de hechos y dimensiones vinculadas, y una estructura organizada para el mantenimiento de medidas DAX.

\- Interfaz de Navegación: Sistema de paneles dinámicos que permiten filtrar la información por temporalidad, ubicación y magnitud de obra.



\## Indicadores y Dashboards

\- Análisis Geográfico: Visualización de densidad de obras y distribución de inversión por comuna.

\- Seguimiento de Objetivos: Panel de control para el monitoreo de metas anuales y cumplimiento de hitos.

\- Análisis de Inversión y Plazos: Desglose de costos por proyecto y métricas de duración promedio para evaluar la eficiencia operativa.

\- Generación de Conclusiones: Implementación de lógica dinámica para la síntesis de hallazgos clave basada en los datos seleccionados.



\## Estructura del Repositorio

\- \*\*\[Observatorio de Obras Urbanas en CABA.pbix](./Observatorio%20de%20Obras%20Urbanas%20en%20CABA.pbix)\*\*: Archivo central con el modelo de datos relacional y los tableros de control interactivos.

\- \*\*\[Documentacion\_Tecnica\_Obras\_CABA.pdf.](./Carpeta Documentacion)\*\*: Informe integral que detalla la metodología técnica, el proceso de transformación (ETL), la arquitectura de las medidas DAX y los activos visuales desarrollados para la interfaz.

\- \*\*\[Obras\_Urbanas\_Dataset](./Carpeta Datos)\*\*: Directorio que contiene los archivos fuente en formato Excel utilizados para la ingesta y el procesamiento de la información.



\---

Tomas Hereñu

Creador del proyecto.

