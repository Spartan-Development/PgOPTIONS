@echo off

set "inputFile=migracion.sql"
set "outputFile=migracion_una_linea.sql"

REM Eliminar comentarios y crear archivo temporal
findstr /v "REM /* --" "%inputFile%" > temp.sql

REM Leer archivo temporal y escribir en una sola línea
setlocal enabledelayedexpansion
set "content="
for /f "usebackq delims=" %%a in ("temp.sql") do (
    set "line=%%a"
    setlocal enabledelayedexpansion
    set "line=!line:~1!"
    
    REM Convertir saltos de línea en espacios
    set "line=!line:^= !"
    
    if defined content (
        endlocal
        set "content=!content!!line!"
    ) else (
        endlocal
        set "content=!line!"
    )
)

REM Guardar el resultado en el archivo de salida
echo !content! > "%outputFile%"

REM Eliminar el archivo temporal
del temp.sql

exit