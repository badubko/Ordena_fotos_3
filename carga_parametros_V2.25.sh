#!/bin/bash
# Version:    	0.2 26/07/17 10:40:02 
#		0.5 29/07/17 14:03:43 
#		0.6 01/08/17 01:18:59  Se agrega el archivo de ARCHIVO_LOG
#                                      Corregida ubicacion de declaracion de WORK_DIR
#				       Agregado " <-----  <MODIFICABLE>"
#                                      Se agrega la variable COMANDO_COMPLETO
#		0.7 02/08/17 11:22:29  Se agregan las variables para la generacion del listado del
#			repositorio; Reordenamiento de las variables.
#		    04/08/17 19:40:54  Se agrega la variable SOLO_REGEN_LISTA_FILES_REP
#		0.8 06/08/17 20:43:40  Esta version agrega los param para la busqueda en Dir0 y Dir1
#		    18/08/17 12:00:30  Se agrego nueva variable RUN_DATE_FILE con formato fecha hora p #				usar en nombres de Archivos
#		    23/08/17 23:13:10  Se agrega la definicion y valores de la variable PREFIJO
#		    24/08/17 22:34:51  Se agrega RUN_DATE_FILE al nombre del archivo de log	
#				se cambian de posicion las generaciones de RUN_DATE y RUN_DATE_FILE
#		    03/09/17 23:01:06  Se agrega ".log" en LISTA_FILES_REP[1]=$WORK_DIR/Lista_Files_Rep_Dir1.log
#		    04/09/17 18:28:44  Se agrega Str_conv_fecha
#		    05/09/17 19:18:13  El Str_conv_fecha es ahora AAAA-MM-DD_HH:MM:SS
#		1.5 08/09/17 00:15:11  Se agrega nuevo nombre de archivo para los comandos de copia de los videos
#			18/09/17 16:24:50	Se agrega la fecha de ejecucion al log de repositorio... Ya se vera su practicidad...
#								Se agrego la variable LISTAR_MODULOS	
#			09/10/17 17:38:03   Se agrego SUB_DIR_NO_COPIAR="Sub_Dir_NO_Copiar" que contendra los archivos
#								con los archivos "NO_COPIAR"
#			06/12/17 16:53:27   Se agrego SWITCH GENERAR_REP_T_PARC
#			11/01/18 10:46:09   Se agrego SWITCH REPORTA_HALLADO_EN_NC
#		1.96 05/04/18 16:45:24   Se usa Lista_Files_No_Copiar_Gral en vez de un file por "NOM_CEL"
#		2.2	 04/06/18 19:05:27	 Se usan los primeros 4 caracteres en COM=${COM:0:4}
#			12/06/18 22:26:07	 Se separaron todas las variables "no modificables"
#--------------------------------------------------------------------------------------------------------

carga_parametros ()
{

#--------------------------------------------------------------------------------------------------------
#PARAMETROS CUSTOMIZABLES
#--------------------------------------------------------------------------------------------------------
# REPOSITORIO y Relacionados
#
# Variable que indica que debemos recrear el listado de archivos contenidos en el repositorio.
# Esto luego deberia ser una opcion en la invocacion.
# Regenera si contiene "TRUE"
# 
# Variable que indica que repositorios a considerar. 
# Permite incluir/excluir al Dir0

REPOS_A_CONS=(1 0)
# REPOS_A_CONS=(0)									# <-----  <MODIFICABLE>

REGEN_LISTA_FILES_REP[1]=TRUE						# <-----  <MODIFICABLE>
REGEN_LISTA_FILES_REP[0]=TRUE						# <-----  <MODIFICABLE>

# Indica que despues de generar el listado de archivos contenidos en el repositorio
# El script termina si contiene "TRUE"

SOLO_REGEN_LISTA_FILES_REP[1]="FALSE"					# <-----  <MODIFICABLE>
SOLO_REGEN_LISTA_FILES_REP[0]="FALSE"					# <-----  <MODIFICABLE>

#-------------------------------------------------------------------------------
#    R E P O S I T O R I O
# DIRECTORIO del Repositorio
#-------------------------------------------------------------------------------
#REPOSITORIO[1]=/media/badubko/Seagate_Backup_Plus_Drive/Public/Dir1

REPOSITORIO[0]=/media/CGate/badubko/Photos/Dir0			# <-----  <MODIFICABLE>
REPOSITORIO[1]=/media/CGate/public/Photos/Dir1			# <-----  <MODIFICABLE>


# Lista de prefijos para separar los nombres de los archivos de Dir1 y Dir0 usados como claves.

# declare -a PREFIJO 
PREFIJO[0]="YXDir0XY" 
PREFIJO[1]="YXDir1XY"

# LISTA Directorios (Años) que incluiremos en el listado del repositorio
# SEPARADOS POR " " espacio en blanco.
# Si la variable es nula... 
# Se incluiran todos los directorios

LISTA_DIRS[0]=""
# LISTA_DIRS[0]="2012 2013 2014 2015 2016 2017 2018"				# <-----  <MODIFICABLE>
#

LISTA_DIRS[1]=""
# LISTA_DIRS[1]="2012 2013 2014 2015 2016 2017 2018"				# <-----  <MODIFICABLE>

#-------------------------------------------------------------------------------
#DIRECTORIO de trabajo
WORK_DIR=~/Work_Dir_Ordena_Fotos_Cel   						# <-----  <MODIFICABLE>
#WORK_DIR=/media/CGate/public/Work_Dir_Ordena_Fotos_Cel   	# <-----  <MODIFICABLE>
#-------------------------------------------------------------------------------
# ARCHIVO  de LOG que contiene Listado de duplicados en repositorios y 
#	el reporte de repositorio.
# Desde version 1.1 en mas, es un log file, ya que se genera una lista en memoria.
# Se agrega la fecha de ejecucion al log de repositorio... Ya se vera su practicidad...

LISTA_FILES_REP[0]=${WORK_DIR}/${RUN_DATE_FILE}"_Lista_Files_Rep_Dir0.log"			# <-----  <MODIFICABLE>
LISTA_FILES_REP[1]=${WORK_DIR}/${RUN_DATE_FILE}"_Lista_Files_Rep_Dir1.log"			# <-----  <MODIFICABLE>
#
#-------------------------------------------------------------------------------------------------------
# Esta variable contiene el nombre de los directorios auto-generados por el NAS 
# para guardar las miniaturas de los files. Estas lineas se eliminaran del listado
# de files del repositorio.
#
#PATRON_DIR_MINIAT_CGATE=983db650f7f79bc8e87d9a3ba418aefc 

PATRON_DIR_MINIAT_CGATE=983db6   				# <-----  <MODIFICABLE>
#--------------------------------------------------------------------------------------------------------
# Nombre/Modelo del Celular
#--------------------------------------------------------------------------------------------------------
# NOM_CEL=BLU_INT
# NOM_CEL=PRUEBA_TRUCH2           				# <-----  <MODIFICABLE>
# NOM_CEL=BLU_SD_Corrupt
#
# NOM_CEL=SDHC1_Basil

# NOM_CEL=Sams_Viejo
# NOM_CEL=Home_DCIM

# NOM_CEL=Home_Fot_Canon_tmp

# NOM_CEL=16GB_Lenta
# 
# NOM_CEL=Sams_Viejo
# 
# 
# NOM_CEL=Fot_XT910_tmp
# 
# NOM_CEL=SDHC1_Basil
# NOM_CEL=Fot_XT910_tmp
# NOM_CEL=Sams_Viejo
# NOM_CEL=Fot_BB_tmp
#
# NOM_CEL=Del_Blu
#
NOM_CEL=Caso_Pru_1_5
#-------------------------------------------------------------------------------
#    C E L U L A R
# DIRECTORIO que contiene archivos de fotos y videos copiados desde el Celular
# Podria ser directamente el directorio MONTADO del celular.
#-------------------------------------------------------------------------------
#  

# DIR_FILES_COPIADOS_DEL_CEL=$WORK_DIR/$NOM_CEL/Files_Copiados_Del_Cel_$NOM_CEL # <-----  <MODIFICABLE>
# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/20170805_SDHC1_Basil

# OOOJJJJOOOO con esto!!! <-----------------
# 
#        # <-----  <MODIFICABLE>

# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/20170809_16GB_Lenta_Back  # <-----  <MODIFICABLE>

# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/Downloads/2018-04-24_BLU_SD_TMP

# DIR_FILES_COPIADOS_DEL_CEL=/media/badubko/SDHC1_BASIL/DCIM
# DIR_FILES_COPIADOS_DEL_CEL=/media/badubko/16GB_LENTA/DCIM

# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/2018-04-27_Back_Samsung_Viejo_TMP
# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/Pictures/DCIM
# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/Pictures/Fotos_XT910_tmp
# 
# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/2018-04-24_Fotos_SD_Cel_Samsung_TMP

# DIR_FILES_COPIADOS_DEL_CEL="/home/badubko/Pictures/Fotos_Samsung_tmp"

# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/Pictures/Fotos_Canon_tmp

# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/2018-04-24_Fotos_SD_Cel_Samsung_TMP

# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/2017-08-09_16GB_Lenta_Back
# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/Pictures_Obsoleto/Fotos_BB_tmp
# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/Pictures_Obsoleto/Fotos_Samsung_tmp
# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/Pictures_Obsoleto/Fotos_XT910_tmp
# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/2017-07-05_SDHC1_Basil_Back

# 
# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/tmp_XT910_back
# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/20170317_Back_Fotos_SD 
# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/2017-07-05_SDHC1_Basil_Back
# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/Pictures_Obsoleto/Fotos_Samsung_tmp
# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/Pictures/2018-04-16_BLU_SD_TMP
# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/Fotos_AR2
# DIR_FILES_COPIADOS_DEL_CEL=/media/badubko/MICRO_SD_2/DCIM/Camera
# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/20180801_Del_Blu_SD2_WH
DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/Work_Dir_Ordena_Fotos_Cel/Para_Caso_Pru_1_5
#-------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------

# DIRECTORIO que contiene la estructura con los subdirectorios y archivos que se copiaran al repositorio
#  ESTR_TEMP_DIR=$WORK_DIR/$NOM_CEL/Estr_Temp_$NOM

ESTR_TEMP="${WORK_DIR}/${NOM_CEL}/Estr_Temp_${NOM_CEL}"

# ARCHIVO que contiene Listado de archivos de fotos y videos contenidos en la estructura temporaria
# 
LISTA_FILES_ESTR_TEMP=$WORK_DIR/$NOM_CEL/Lista_Files_Estr_Temp_$NOM_CEL

# ARCHIVO que contiene la lista de archivos de fotos y videos que NO se copiaran desde el celular al
#   repositorio.
# Se crea en el WORK_DIR para que pueda sobrevivir a la re-creacion de la 
#
SUB_DIR_NO_COPIAR="Sub_Dir_NO_Copiar"						# <-----  <MODIFICABLE>
LISTA_FILES_NO_COPIAR=${WORK_DIR}"/${SUB_DIR_NO_COPIAR}/Lista_Files_No_Copiar_Gral"

# ARCHIVO que contiene Listado de archivos de fotos y videos contenidos en el Celular
#							!!!!!! NO SE USA !!!!!!
# LISTA_FILES_CEL=$WORK_DIR/Lista_Files_Cel_$NOM_CEL
#-------------------------------------------------------------------------------------
# ARCHIVO de LOG donde se guardaran los nombres de los objetos que son informados y que se deberan
# revisar.
#
ARCHIVO_LOG=${WORK_DIR}/${NOM_CEL}/${RUN_DATE_FILE}'_Arch_Log_'${NOM_CEL}'.log'
#
#-------------------------------------------------------------------------------------
# ARCHIVO donde iran los comandos para copiar los videos en modo diferido.
#
WORK_SCRIPT_VID=${WORK_DIR}/${NOM_CEL}/${RUN_DATE_FILE}'_W-S_VID_'${NOM_CEL}'.sh'


#-------------------------------------------------------------------------------------
# Permite la invocacion a listar_modulos en Verifica...
# Mas adelante podria ser una opcion de invocacion.

LISTAR_MODULOS="TRUE"									# <-----  <MODIFICABLE>

# Para generar el reporte de Tiempos parciales de ejecucion
GENERAR_REP_T_PARC="TRUE" 							#<-----  <MODIFICABLE>

# Para reportar las lineas halladas en N/C
REPORTA_HALLADO_EN_NC="TRUE" 						#<-----  <MODIFICABLE>

# Para reportar contendido de los zip
REPORTE_DEL_ZIP="FALSE"

return
}
