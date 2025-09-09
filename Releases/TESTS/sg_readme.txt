           _________________REQUERIMIENTOS____________________
EL simpleGestor se encarga de crear uno varios script BAT o SHELL, cada cual con un query que actualizara la base de datos correspondiente.

Los puntos a considerar son los siguientes:

primer menu
*ELEGIR QUE TIPO DE SCRIPT CREAR (bat/sh).
 1.-BATCH (WINDOWS)
 2.-SHELL (LINUX)

*NOMBRE DE LA BASE DATOS QUE SE VA ALTERAR.

*ACCION QUE SE DESEA REALIZAR MOSTRANDO UN PEQUEÑO MENU:
Segundo Menu
_GENERAR SCRIPT PARA ALTERAR LA BD "NOMBRE_db"

 *SCRIPT CREAR TABLA.
  **Nombre de la tabla.
    -CREAR COLUMNAS TIPO NUMERIC.
    -CREAR COLUMNAS TIPO CHARACTER VARING
    -CREAR COLUMNAS TIPO CHARACTER
    -CREAR COLUMNAS TIPO DATE
    -SALIR
 
 *SCRIPT ACTUALIZAR TABLA.
   **Nombre de la tabla.
    -CREAR COLUMNAS TIPO NUMERIC.
    -CREAR COLUMNAS TIPO CHARACTER VARING
    -CREAR COLUMNAS TIPO CHARACTER
    -CREAR COLUMNAS TIPO TIMESTAMP WITHOUT TIME ZONE
    -SALIR
 *TERMINAR.

LOS PARAMETROS DEL SCRIPT GENEARDO SERAN LOS SIGUIENTES:
-EN EL SCRIPT:
DEFAULT:
HOST: localhost
PORT: 5432
 *USAR HOST Y PUERTO POR DEFECTO (S/N):Y
 *si es 'y' o 'Y', entoces muestra el primer menu, sino, se configura el host y el puerto.
 MUESTRA LOS DATOS A CONFIRMAR LUEGO
Ejecutar Script (S/N)? Si es Si... Se ejecutara.