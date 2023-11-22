# TPE-ProcesamientoXML-72.32
Trabajo Especial de Diseño y Procesamiento de Documentos XML.
## Correcciones: 
- La API_KEY está cableada dentro del SH.
- Si no está el prefijo produce error en tiempo de ejecución

## Notas:
- Para el manejo de errores faltó contemplar el caso en el que la season_id es inexistente (se le pasa "Hola" por parámetro por ejemplo). Se debería haber contemplado el caso límite en que la búsqueda del id devuelve _null_.
