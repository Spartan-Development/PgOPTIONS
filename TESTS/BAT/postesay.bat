@echo off
setlocal EnableDelayedExpansion

echo Host y puerto configurados:
echo ---------------------------
echo Host: localhost
echo Puerto: 5432
echo.

pause

:inicio
set /p user=Ingrese el nombre de usuario: 
set /p db=Ingrese el nombre de la base de datos a utilizar: 

:menu
echo.
echo _______MENU DE OPERACIONES CON LA BASE DE DATOS__________
echo        1. MOSTRAR TABLAS.
echo        2. CREAR NUEVA COLUMNA EN UNA TABLA.
echo        3. CREAR VARIAS COLUMNAS EN UNA TABLA.
echo        4. VACIAR UNA TABLA.
echo        5. EJECUTAR UNA SENTENCIA.
echo        6. Salir.
echo ____________________________
set /p opcion=Ingrese una opción: 

if %opcion%==1 (
    echo Mostrando tablas de la base de datos %db%...
    echo -----------------------------------------
    psql -U %user% -h localhost -p 5432 -d %db% -c "\dt"
    echo -----------------------------------------
    pause
    goto menu
) else if %opcion%==2 (
    set /p tabla=Ingrese el nombre de la tabla: 
    set /p columna=Ingrese el nombre de la columna a crear: 
    set /p tipo=Ingrese el tipo de dato: 
    echo Creando nueva columna %columna% en la tabla %tabla%...
    echo -----------------------------------------------------
    psql -U %user% -h localhost -p 5432 -d %db% -c "ALTER TABLE %tabla% ADD COLUMN %columna% %tipo%"
    echo -----------------------------------------------------
    pause
    goto menu
) else if %opcion%==3 (
 echo HOLA 4
) else if %opcion%==4 (
 echo HOLA 4
) else if %opcion%==5 (
 echo HOLA 5
pause
) else if %opcion%==6 (
 echo HOLA 6
pause
) else (
 echo HOLA
 pause
)

