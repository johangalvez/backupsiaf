CLEAR

?"-- Inicia Prorama --"
** Cargando las rutas:
LOCAL lnFileHandle && numeric file handle
*PATHAPP = "c:\users\lgalvez\documents\personal\proyectos\foxpros\"
lnFileHandle = FOPEN( "d:\SIAFBACKUP\rutasiaf.txt")
IF lnFileHandle = -1
   && error, could not open the file
   && do something to handle the error
   ?"Error al leer par�metros"
   RETURN
ENDIF

PATHAPP = FGETS( lnFileHandle)
?"PATHAPP:" + PATHAPP
PATHSIAF = FGETS( lnFileHandle)
?"PATHSIAF:" + PATHSIAF

FCLOSE( lnFileHandle) && don't forget to close the file

PATHDATA = "DATASIAF"+ PADL(YEAR(DATETIME( )), 4) + PADL(MONTH(DATETIME( )), 2) + PADL(DAY(DATETIME( )), 2, '0') + PADL(HOUR(DATETIME( )), 2, '0') + PADL(MINUTE(DATETIME( )), 2, '0')
*PATHSIAF = "D:\SIAF_2020\SIAF_2020\DATA\"
*SET DEFAULT TO HOME( )  && Restore Visual FoxPro directory
CHDIR (PATHAPP)
MKDIR (PATHDATA)  && Create a new directory
? "Se cre� la carpeta " + PATHDATA
CHDIR (PATHDATA)  && Change to the new directory


 
?"-- Inicia copia de tablas --"

fTablas = FILETOSTR("d:\SIAFBACKUP\tablas.txt") && appends string
CREATE DATABASE ("SIAF2.DBC")
OPEN DATABASE (PATHSIAF + "SIAF.DBC") SHARED

	FOR nI = 1 TO ALINES(aLineas, fTablas)
	  * buscar en aLineas[nI]
	  tabla = aLineas[nI]
	  *?tabla
	  USE "SIAF!"+tabla SHARED &&expediente_nota
	    COPY TO (tabla) ;
	      DATABASE ("SIAF2.DBC") NAME (tabla)  WITH CDX
	  ?"Se copio " + PADR(tabla, 40, '-') + "-" + PADL(HOUR(DATETIME( )), 2, '0') + ":" + PADL(MINUTE(DATETIME( )), 2, '0')
 	ENDFOR
CLOSE DATABASES
