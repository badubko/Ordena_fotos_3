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
#--------------------------------------------------------------------------------------------------------

carga_parametros ()
{

# RUN_DATE Fecha y hora de la ejecucion del script
RUN_DATE="$(date  +\#\ %Y\/%m\/%d\ %H:%M)"
RUN_DATE_FILE="$(date  +%Y-%m-%d_%H%M)"    # Nuevo formato para usar en nombres de Archivo

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
#DIRECTORIO de trabajo
WORK_DIR=~/Work_Dir_Ordena_Fotos_Cel   						# <-----  <MODIFICABLE>
#WORK_DIR=/media/CGate/public/Work_Dir_Ordena_Fotos_Cel   	# <-----  <MODIFICABLE>

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
# ARCHIVO que contiene Listado de Directorios y archivos contenidos en el repositorio de fotos y videos
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

# NOM_CEL=BLU_INT
# NOM_CEL=PRUEBA_TRUCH2           				# <-----  <MODIFICABLE>
# NOM_CEL=BLU_SD_Corrupt
#
# NOM_CEL=SDHC1_Basil

# NOM_CEL=Caso_Pru_1_5

# NOM_CEL=16GB_Lenta
# NOM_CEL=Sams_Viejo
# NOM_CEL=Home_DCIM
# NOM_CEL=Fot_XT910_tmp
# NOM_CEL=Fot_BB_tmp

# NOM_CEL=Home_Fot_Canon_tmp

# NOM_CEL=16GB_Lenta
# NOM_CEL=Del_Blu
# NOM_CEL=Fot_BB_tmp
# NOM_CEL=Sams_Viejo
# NOM_CEL=Fot_XT910_tmp
# NOM_CEL=Caso_Pru_1_5
# NOM_CEL=Del_Blu

NOM_CEL=SDHC1_Basil
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
# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/20170317_Back_Fotos_SD 	       # <-----  <MODIFICABLE>

# DIR_FILES_COPIADOS_DEL_CEL=/media/badubko/MICRO_SD_2/DCIM/Camera
# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/tmp_XT910_back
# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/20170809_16GB_Lenta_Back  # <-----  <MODIFICABLE>

# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/Downloads/2018-04-24_BLU_SD_TMP

# DIR_FILES_COPIADOS_DEL_CEL=/media/badubko/SDHC1_BASIL/DCIM
# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/Work_Dir_Ordena_Fotos_Cel/Para_Caso_Pru_1_5
# DIR_FILES_COPIADOS_DEL_CEL=/media/badubko/16GB_LENTA/DCIM

# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/2018-04-27_Back_Samsung_Viejo_TMP
# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/Pictures/DCIM
# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/Pictures/Fotos_XT910_tmp
# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/Pictures/Fotos_BB_tmp
# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/2018-04-24_Fotos_SD_Cel_Samsung_TMP

# DIR_FILES_COPIADOS_DEL_CEL="/home/badubko/Pictures/Fotos_Samsung_tmp"

# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/Pictures/Fotos_Canon_tmp

# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/2018-04-24_Fotos_SD_Cel_Samsung_TMP

# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/2017-08-09_16GB_Lenta_Back
# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/Pictures_Obsoleto/Fotos_BB_tmp
# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/Pictures_Obsoleto/Fotos_Samsung_tmp
# DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/Pictures_Obsoleto/Fotos_XT910_tmp
# DIR_FILES_COPIADOS_DEL_CEL=/home/badubko/Work_Dir_Ordena_Fotos_Cel/Para_Caso_Pru_1_5

DIR_FILES_COPIADOS_DEL_CEL=/media/CGate/public/2017-07-05_SDHC1_Basil_Back

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
#
# String para convertir fecha de exiftool   
#             AAAA:MM:DD HH:MM:SS
# a formato   AAAA-MM-DD_HH:MM:SS

Str_conv_fecha='s/.*([0-9]{4}):([0-9]{2}):([0-9]{2}) (.*)/\1-\2-\3_\4/'

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

#-------------------------------------------------------------------------------------
# Nombre abreviado del script en ejecucion... para que los mensajes sean mas legibles.

VERS=${0##*_} 		# Elimina /abc/def/ghi/./Gen_list_files_cel_NO_copiar_  Queda "V0.5.sh"
VERS=${VERS%.*} 	# Elimina ".sh"  Queda "V0.5"

COM=${0%_*}    				#; echo $COM   # ELimina "_V0.5.sh"
COM=${COM##*/} 				#; echo $COM   # Elimina "/abc/def/ghi/./"
COMANDO_COMPLETO=${COM}   	# Para determinar que secciones ejecutar en Verifica.. y Genera
COM=${COM:0:4} 				#; echo $COM   # Solo los primeros 4 caracteres

NOM_ABREV=${COM}'..'${VERS}
#-------------------------------------------------------------------------------------
# echo "$VERS $COM $COMANDO_COMPLETO $NOM_ABREV"
# exit

return
}
#!/bin/bash
# Version:	0.7 Se crea esta funcion
#		    04/08/17 19:31:31 Agregada la variable SOLO_REGEN_LISTA_FILES_REP
#	                              si contiene "TRUE" despues de generar la lista termina.
#		0.8 se agrega la creacion de los listados de los contenidos de Dir0 y Dir1
#		0.81 13/08/17 16:55:12  Se agrega la verificacion si los directorios de los años solicitados
#					existen y si no existe ningun año, salir
#                   Los flags (TRUE,etc) se convierten a mayusculas por las dudas.
#					${REGEN_LISTA_FILES_REP[$indice]^^} = "TRUE" 
#       0.9 24/08/17 08:42:22 Version DESCARTADA que crea la lista de los repositorios en memoria invocando 
#                             la funcion generar_lista_rep_en_mem
#				Se cambia variable indice por NUM_REPOS
#				No hay opcion de "reusar" listado ya que es en memoria
#		V1.1 24/08/17 19:41:09  Se incluyen las funciones del archivo generar_list_rep_en_mem_V0.9
#				para simplificar el esquema.
#				Se agregan las funciones reporte_de_repositorio y crea_listado_repositorio 
#				Se corrige reporte_de_duplicados para que informe Duplicados y Copias de ambos
#				repositorios.
#		     04/09/17 19:49:10 Se cambia echo por printf en el reporte_de_repositorio
#		     08/09/17 11:19:06 Se modifican las listas de tipos de extension y se pasa a minuscula
#			 19/09/17 00:59:12 Mejora de formatos y uso printf en reportes
#		V2.0 06/04/18 11:06:43 Se incluye el procesamiento de los archivos contenidos dentro de archivos zip
#			 16/04/18 13:24:41 Se modifica el agregado de sinonimos, usandose un contador
#			  				    Se contabilizan y reportan la cant de archivos zip
#			23/04/18 15:37:28  Se agrega func z_reporte_del_zip y se completa z_procesar_zip
#			29/04/18 00:41:22  z_reporte_del_zip se agregan las variantes para TRUE y FALSE
#								y se reacomoda el orden de las lineas reportadas
#			12/05/18 20:23:29  Se corrigio insertar_sinonimo
#		V2.1 12/05/18 22:24:54 Se agrega funcion insertar_copia y se separan los contadores
#			15/05/18 10:21:41 Se corrigio en z_procesar_zip insertar_copia en el caso __C
#								Se agrego else en el if #1 de z_procesar_zip
#			15/05/18 13:31:38 Se convierte a minuscula el tipo de expension para evitar caso de jpg vs JPG
#			24/05/18 22:10:17 Se agrega tipo mjpeg como tipo video.
#
# Verificar si el Directorio del repositorio es accesible
# Regenerar la lista de contenidos de acuerdo a indicacion de REGEN_LISTA_FILES_REP
# Incluyendo los años seleccionados o todos los años, de acuerdo al parametro
#  $LISTA_DIRS
#  que puede estar vacio o contener los años que se quieran considerar.

# Se eliminan las lineas que contengan los directorios de las miniaturas
# cuyo nombre esta en PATRON_DIR_MINIAT_CGATE.

# Ordenar la lista en forma decreciente.
# Generado por solo por Fotos_cel_a_Estr_Temp

z_reporte_del_zip ()
{
	
# TRUE ---> lista en terminal y en log
# FALSE---> Solo en log

fmt1='%-20s:%8d\n'

if [ ${REPORTE_DEL_ZIP} = "TRUE" ]
then

printf "%s:\n" ${FUNCNAME}								| tee -a ${LISTA_FILES_REP[$NUM_REPOS]} 
printf "%s\n" "Nombre del zip file: "					| tee -a ${LISTA_FILES_REP[$NUM_REPOS]}
printf "%s:\n" ${full_path_name}						| tee -a ${LISTA_FILES_REP[$NUM_REPOS]} 
printf "Cant de Lineas: %4s\n"  ${#Z_Lineas[@]} 		| tee -a ${LISTA_FILES_REP[$NUM_REPOS]} 

printf "${fmt1}" "Tot Files en ZIP  " ${Z_TOT_FILES}	| tee -a ${LISTA_FILES_REP[$NUM_REPOS]}
printf "${fmt1}\n" "Tot Espureos ZIP" ${Z_TOT_ESPUREOS}	| tee -a ${LISTA_FILES_REP[$NUM_REPOS]}

else

printf "%s:\n" ${FUNCNAME}								>> ${LISTA_FILES_REP[$NUM_REPOS]} 
printf "%s\n" "Nombre del zip file: "					>> ${LISTA_FILES_REP[$NUM_REPOS]}
printf "%s:\n" ${full_path_name}						>> ${LISTA_FILES_REP[$NUM_REPOS]} 
printf "Cant de Lineas: %4s\n"  ${#Z_Lineas[@]} 		>> ${LISTA_FILES_REP[$NUM_REPOS]}

printf "${fmt1}" "Tot Files en ZIP  " ${Z_TOT_FILES}	>> ${LISTA_FILES_REP[$NUM_REPOS]}
printf "${fmt1}\n" "Tot Espureos ZIP" ${Z_TOT_ESPUREOS}	>> ${LISTA_FILES_REP[$NUM_REPOS]}

fi



}

z_procesar_zip ()
{

## Obtenemos listado de lo que contiene el zip file
mapfile -t Z_Lineas <  <( /usr/bin/unzip -l -qq  ${full_path_name} )

# printf "Cant de Lineas en arch ${full_path_name} : %4s\n"  ${#Z_Lineas[@]}

let Z_TOT_FILES=0				# Total de archivos en este zip

let Z_TOT_ESPUREOS=0			# Total de archivos espureos en este zip ????



if [ ${#Z_Lineas[@]} = 0  ]
then  # No hay elementos en el zip file 
	return
fi

DE_ZIP="TRUE" 

let Z_TOT_LIN=${#Z_Lineas[@]}-1
let Z_linecount=0


while [ ${Z_linecount} -le ${Z_TOT_LIN} ]
do
	read  Z_TAM Z_FECHA Z_HORA Z_NOMBRE <<<${Z_Lineas[${Z_linecount}]}
	Z_FECHA_HORA="${Z_FECHA}_${Z_HORA}:00"  # Aca agregamos :00 para mantener el formato
											# AAAA-MM-DD_HH:MM:SS
											# Esta fecha NO SIRVE para comparar...
 
	Z_NOMBRE=${Z_NOMBRE##*/}			# Eliminamos cualquier directorio.
		
							# Si es un directorio dentro del zip lo salteamos
	if [ ${#Z_NOMBRE} = 0 ]
    then
#		echo "Nombre nulo: "
		let Z_linecount++
		continue
	fi
	 
	Z_TIPO_EXTENS=${Z_NOMBRE##*.}  		# --->>>> Obtener Extension de tipo
   
	Z_TIPO_EXTENS="${Z_TIPO_EXTENS,,}" 		# Pasamos a minuscula el tipo de extension para simplificar la lista.
	
	Z_NOMBRE=${Z_NOMBRE%.*}"."${Z_TIPO_EXTENS}  # Sustituimos la extension en minuscula
    
    
	let Z_TOT_FILES++
 
	indice_hash=${PREFIJO[${NUM_REPOS}]}"${Z_NOMBRE}"
 
 	case "${Z_TIPO_EXTENS}" in  # Ya llega en minuscula
	bmp |  gif | jpg | jpeg | tiff | png | 3gp | avi | mov | qt | mpg| mpeg4 | mp4 | wav | wmv | divx | mjpeg )
	
		if [    "${#Lista_files_index[${indice_hash}]}" = 0  ] # 3
  	 	then 
			
          		Lista_files_index[${indice_hash}]="${full_path_name}"   # <<---- Ver que nombre ponemos aqui !!
          		Tam_File[${indice_hash}]=${Z_TAM}           # Guardamos el tamaño del file
															## ya que luego seria complicado obtenerlo.
				Fecha_File[${indice_hash}]=${Z_FECHA_HORA}
				UNZIPED[${indice_hash}]=${DE_ZIP}
				let REP_CANT_SINON[${indice_hash}]=0
				
 							## No estaba registrado este nombre de archivo 
					    	## usado como indice_hash ; Lo agregamos
							## Como viene de zip guardamos tamaño del primario 
							
  	 	else # 3
			
			if [ ${#Tam_File[${indice_hash}]} = 0 ] # 1
			then
				# Era un primario que no venia de un zip y no habia sinonimos.
				
				Tam_Orig="$(stat -c '%s' ${Lista_files_index[$indice_hash]} )"
				
				# Guardamos el tamaño para la proxima
				
				Tam_File[${indice_hash}]=${Tam_Orig}
			else #1
				# Ya habia tamaño. Lo recuperamos para el if de mas abajo. 
				
				Tam_Orig=${Tam_File[${indice_hash}]}
		    fi #1
			
			Tam_Intruso=${Z_TAM}            # Guardamos el tamaño del intruso
											# que viene de un zip.
         
			if [ "${Tam_Orig}" != "${Tam_Intruso}" ]  #2
			then
				## El tamaño es "!="  ->> Nombre Duplicado
				## Probablemente es un archivo diferente con el mismo nombre
				#  (Ojo que aca NO comparamos fechas para no perder tiempo...)  
				let TOT_NOMBRES_DUPLICADOS++	
						SUFIJO="__D"
						insertar_sinonimo	 #--------->>># 	
	  		else # 2
				## Tamaño "=" ->>  Es una copia del archivo en otro lugar.
				let TOT_ARCH_COPIA++	
						SUFIJO="__C"
						insertar_copia			#--------->>># 
			fi # 2
		fi # 3		
	;; 
	*)
		## echo "Extension que no aplica"   		
		let TOT_ESPUREOS++
		let Z_TOT_ESPUREOS++
	;;
	esac	  
 
	let Z_linecount++
done  # Del while

z_reporte_del_zip							#--------->>># 

}


#-------------------------------------------------------------------------------
insertar_sinonimo ()
{	
											#
# index=${indice_hash}${SUFIJO}				
											# Incrementamos el contador de 
											# Duplicados __D o Copias __C
# let REP_CANT_SINON[${index}]++
let REP_CANT_SINON[${indice_hash}]++		# La cant de sinonimos va en el primario solamente
										    # Para acortar la variable en el prox paso
# contad=${REP_CANT_SINON[${index}]}
contad=${REP_CANT_SINON[${indice_hash}]}

index=${indice_hash}${SUFIJO}${contad}				
# index=${index}${contad}     	# Ejemplo: "Nombrearchivo""__D"1 o Nombrearchivo__C1

Lista_files_index[${index}]=${full_path_name} # Guardar el pathname completo como sinonimo

Tam_File[${index}]=${Tam_Intruso}				# Guardar el tamaño del nuevo file duplicado
											# Sea Copia o Duplicado, igual lo guardamos
											# por si en algun momento queremos hacer alguna
											# estadistica.
UNZIPED[${index}]=${DE_ZIP}

# No tiene sentido guardar esta fecha. Revisar...
#if [ ${DE_ZIP} = "TRUE" ]
#then
#	Fecha_File[${index}]=${Z_FECHA_HORA}
#fi


}
#-------------------------------------------------------------------------
insertar_copia ()
{
let REP_CANT_COP[${indice_hash}]++		# La cant de Copias va en el primario solamente
contad=${REP_CANT_COP[${indice_hash}]}
index=${indice_hash}${SUFIJO}${contad}				
Lista_files_index[${index}]=${full_path_name} # Guardar el pathname completo como copia

Tam_File[${index}]=${Tam_Intruso}				# Guardar el tamaño del nuevo file duplicado
											# Sea Copia o Duplicado, igual lo guardamos
											# por si en algun momento queremos hacer alguna
											# estadistica.
UNZIPED[${index}]=${DE_ZIP}	
}

#-------------------------------------------------------------------------------
#	  V4.4  19/08/17 23:19:11 Se corrige tratamiento de ESPUREOS:
#				Se contabilizan
#				Opcional: se listan
#				NO se incluyen en estuctura ni se generan sinonimos
#				NO se listan los DUPLICADOS ni COPIA ; seria una opcion
#				se crea la funcion generar_lista_rep_en_mem
#	  v4.5  21/08/17 22:41:42 Version con variables preparadas para integrarse en el script 
#				fotos_cel_a_estr_temp
#
#	  v0.9  21/08/17 23:08:45 Creada a partir de detecta_dupl_en_repos_V4.4 como una funcion
#				en archivo separado.
#				Se cambian nombres de variables para que no haya superposicion.
#				Se vuelve a agregar el sort en la creacion de la lista del repositorio
#				para que el el file "original" sea el mas antiguo y los siguientes
#				sean los duplicados o copias.
# 				Se agrega un prefijo que indica de que repositorio es la lista
#-------------------------------------------------------------------------------
generar_lista_rep_en_mem ()
{


let TOT_FILES=0
let TOT_ARCH_COPIA=0        	# Mismo ARCH en Distintas locaciones
let TOT_NOMBRES_DUPLICADOS=0    # Igual nombre Distinto contenido (en realidad distinta fecha)

let CANT_ARCH_ZIP=0				# La cant de archivos zip en el repositorio
let TOT_ARCH_EN_ZIP=0 			# La cant total de arch contendidos en todos los zip

let TOT_ESPUREOS=0				# Extension de tipo ni de fotografia ni de video 	



Lista_files=$(find $(echo ${TARGET_DIRS[$NUM_REPOS]}) -type f | grep -v ${PATRON_DIR_MINIAT_CGATE} | sort )

    Tfind=$(date +%s)
    echo ${Tfind} 
 	echo "Tiempo find: " $((Tfind-T0))	

for full_path_name in ${Lista_files[@]}
do

  nom_file=${full_path_name##*/} 	# EL indice_hash es el NOMBRE DEL ARCHIVO; 
					# Eliminar Longest match de todo lo que preceda a /
					# Equivalente a basename, pero mas rapido: Esto lo hace bash...
					#
	TIPO_EXTENS=${nom_file##*.}  		# --->>>> Obtener Extension de tipo
	TIPO_EXTENS="${TIPO_EXTENS,,}" 		# Pasamos a minuscula el tipo de extension para simplificar la lista.
	
	nom_file=${nom_file%.*}"."${TIPO_EXTENS}  # Sustituimos la extension en minuscula
	
	let TOT_FILES++ 			# Contabilizar el TOT de archivos
  
	# El nombre de archivo usado como indice_hash esta ya registrado
	# Determinar el tamaño segun el tipo de extension, descartando las invalidas.
	# Le agregamos el prefijo al nombre del archivo, para considerar el repositorio.
    #

    indice_hash=${PREFIJO[$NUM_REPOS]}"${nom_file}"
 #       echo "Paso x 94" $indice_hash ${TIPO_EXTENS} 
  
	case "${TIPO_EXTENS}" in  # Ya llega pasada a minuscula
	 bmp |  gif | jpg | jpeg | tiff | png | 3gp | avi | mov | qt | mpg| mpeg4 | mp4 | wav | wmv | divx | mjpeg )
	 	
	 	DE_ZIP="FALSE" # Estamos procesando archivos que no vienen de un zip.
	 	
	 	if [    "${#Lista_files_index[${indice_hash}]}" = 0  ] 
  	 	then 
  	 			# No estaba registrado este nombre de archivo 
				# usado como indice_hash ; Lo agregamos
				# NO guardamos tamaño del primario para evitar
				# hacerlo para todos los archivos del repositorio
				# Se guardara solo si hay un sinonimo.
          		Lista_files_index[${indice_hash}]="${full_path_name}" 
          		
				# Se pone en cero el contador de sinonimos ya que hasta aca no los hay.			
				let REP_CANT_SINON[${indice_hash}]=0
				# Este archivo no estaba en un zip
				UNZIPED[${indice_hash}]=${DE_ZIP}
  	 	else
			# Hay un ocupante ...
			if [ ${UNZIPED[${indice_hash}]}	= "FALSE" ]
			then
				# Ocupante no viene de un zip --> 
				# averiguar tamaño si es que no hay sinonimos...
				# Siempre se va a comparar con el primario. Esto no es demasiado fino
				# pero funciona y sirve para lo que estamos haciendo
				# Ejemplo: se podrian tener archivos de igual tamaño como sinonimos "D"
				# al ser el primer sinonimo de tamaño distinto al primario pero 
				# luego  un segundo sinonimo de tamaño igual al primero.
				
#				echo "${REP_CANT_SINON[${indice_hash}]}"
				if [ ${REP_CANT_SINON[${indice_hash}]} = 0 ]
				then 
					Tam_Orig="$(stat -c '%s' ${Lista_files_index[$indice_hash]} )"
					
					# Guardamos el tamaño del primario una sola vez
					Tam_File[${indice_hash}]=${Tam_Orig}
#					echo "UNZIPED: ${UNZIPED[${indice_hash}]} Tam: ${Tam_Orig}"
				fi
			fi

			Tam_Intruso="$(stat -c '%s' ${full_path_name} )"

			if [ "${Tam_File[${indice_hash}]}" != "${Tam_Intruso}" ]
			then
				# El tamaño es "!="  ->> Nombre Duplicado
				# es un archivo diferente con el mismo nombre  
#				  echo "Tam_Orig: ${Tam_File[${indice_hash}]}  Tam_intr: ${Tam_Intruso}"
				  let TOT_NOMBRES_DUPLICADOS++	
		                  SUFIJO="__D"
		                  insertar_sinonimo	 #--------->>># 	
	  		else
				# Tamaño "=" ->>  Es una copia del archivo en otro lugar.
#				  echo "Tam_Orig: ${Tam_File[${indice_hash}]}  Tam_intr: ${Tam_Intruso}"
				  let TOT_ARCH_COPIA++	
						SUFIJO="__C"
						insertar_copia			#--------->>># 
			fi
		fi		
	;;      

	zip )
		let CANT_ARCH_ZIP++
		z_procesar_zip						#--------->>># 
	
	;;
	*)
		# echo "Extension que no aplica"   		
		let TOT_ESPUREOS++
	;;
	esac	        
done

# Esto lo hacemos para poder generar el listado del proximo repositorio.
unset -v Lista_files
}	

#----------------------------------------------------------------------------------------
reporte_de_repositorio ()
{
fmt1='%-20s:%8d\n'


    printf "%s:\n" ${FUNCNAME}								 | tee -a ${LISTA_FILES_REP[$NUM_REPOS]} 
    # Ya lo habiamos publicado
	printf "${fmt1}" "Tiempo find"  $((Tfind-T0))  			>>${LISTA_FILES_REP[$NUM_REPOS]} 
	
	printf "${fmt1}" "Tiempo Total Rep"  $((Tfin-T0))	 	 | tee -a ${LISTA_FILES_REP[$NUM_REPOS]}
    printf "${fmt1}" "Total Files" ${TOT_FILES} 		 	 | tee -a ${LISTA_FILES_REP[$NUM_REPOS]}
	printf "${fmt1}" "Duplicados"  ${TOT_NOMBRES_DUPLICADOS} | tee -a ${LISTA_FILES_REP[$NUM_REPOS]}
    printf "${fmt1}" "Copia"       ${TOT_ARCH_COPIA}         | tee -a ${LISTA_FILES_REP[$NUM_REPOS]}
    printf "${fmt1}" "ZIP  "       ${CANT_ARCH_ZIP}          | tee -a ${LISTA_FILES_REP[$NUM_REPOS]}
    printf "${fmt1}\n" "Espureos"  ${TOT_ESPUREOS}           | tee -a ${LISTA_FILES_REP[$NUM_REPOS]}
	 

return
}
#----------------------------------------------------------------------------------------
reporte_de_duplicados ()
{
printf "%s:\n" ${FUNCNAME}										| tee -a ${LISTA_FILES_REP[$NUM_REPOS]}
printf "${fmt1}\n" "Cant Elem Array: " ${#Lista_files_index[@]} | tee -a ${LISTA_FILES_REP[$NUM_REPOS]}


for suf in '__D' '__C' 
do
SELECC=${PREFIJO[${NUM_REPOS}]}'.*'"${suf}"  #  Ej: XYDir1YXIMG9999.jpg__D o XYDir0YXIMG9999.jpg__C
INDICES_ORDENADOS="$(echo ${!Lista_files_index[@]} | tr " " "\n" | sort | grep "${SELECC}" )"

    echo												>> ${LISTA_FILES_REP[$NUM_REPOS]}
	for ind in $(echo ${INDICES_ORDENADOS})
	do
		echo 												>> ${LISTA_FILES_REP[$NUM_REPOS]}
		ind_orig=${ind%${suf}*}    #indice primario= Nombre orig; sin "__D2" o "__C1"
								   # Listamos el primario y el sinonimo.
		echo ${ind_orig} ${Lista_files_index[${ind_orig}]}	>> ${LISTA_FILES_REP[$NUM_REPOS]}
		echo ${ind} ${Lista_files_index[${ind}]}			>> ${LISTA_FILES_REP[$NUM_REPOS]}   
	done
done


return
}
#----------------------------------------------------------------------------------------
crea_listado_repositorio ()
{
# Comenzamos por Dir1 previendo para mas adelante Omitir buscar en Dir0
# Ver carga parametros.

					 # El orden en REPOS_A_CONS es 1 0
for NUM_REPOS in ${REPOS_A_CONS[@]}      # <---- Cambiada variable indice por NUM_REPOS
do
	if [ ! -d ${REPOSITORIO[$NUM_REPOS]} ] #4
	then
		echo "$NOM_ABREV: ${REPOSITORIO[$NUM_REPOS]} esta incaccesible"
		exit
	else #4
		echo "$NOM_ABREV: ${REPOSITORIO[$NUM_REPOS]} ACCESIBLE"
		# Generar la lista de archivos contenidos en el repositorio

		if [ ${REGEN_LISTA_FILES_REP[$NUM_REPOS]^^} = "TRUE"  ] #3
		then
			echo "$NOM_ABREV: Creando ${LISTA_FILES_REP[$NUM_REPOS]}" 
			echo "# Creado por: $0"               >${LISTA_FILES_REP[$NUM_REPOS]}
			echo $RUN_DATE      		         >>${LISTA_FILES_REP[$NUM_REPOS]}

			if [ -n "${LISTA_DIRS[$NUM_REPOS]}" ] #2
			then   
				# LISTA_DIRS contendra la lista de años a incluir
				# Aca se arman los directorios completos con todos los años a incluir
				# Seria mas simple hacerlo en carga_parametros poniendo el pathname completo? 
				for DIR in ${LISTA_DIRS[$NUM_REPOS]}
				do
				   # Verificar si los años solicitados existen. 
				   if [ ! -d "${REPOSITORIO[$NUM_REPOS]}/${DIR}" ] #1
				   then
					echo "$NOM_ABREV: ${REPOSITORIO[$NUM_REPOS]}/${DIR} no existe; ignorado"
				   else #1
					TARGET_DIRS[$NUM_REPOS]="${TARGET_DIRS[$NUM_REPOS]} ${REPOSITORIO[$NUM_REPOS]}/$DIR"
				   fi #1
				done

				# SI no existe ninguno de los años solicitados salir
				if [ -z "${TARGET_DIRS[$NUM_REPOS]}" ] #1.1
				then
					echo "$NOM_ABREV: Ninguno de los años solicitados existe"
					exit  # Salir 
				fi #1.1
				
			 else  #2
				TARGET_DIRS[$NUM_REPOS]=${REPOSITORIO[$NUM_REPOS]}
			 fi #2
						  
			echo "Se consideran los siguientes Sub-DIRECTORIOS:" 	>>${LISTA_FILES_REP[$NUM_REPOS]}
			echo "${TARGET_DIRS[$NUM_REPOS]}"						>>${LISTA_FILES_REP[$NUM_REPOS]}
			echo													>>${LISTA_FILES_REP[$NUM_REPOS]}
			echo													>>${LISTA_FILES_REP[$NUM_REPOS]}
			T0=$(date +%s)
			echo ${T0} 

			generar_lista_rep_en_mem        #  ------------->>> Aca esta la madre de Dorrego

			Tfin=$(date +%s)
			echo ${Tfin} 
							#  ------------->>>  Aca se generan listados para ver que encontramos.
			reporte_de_repositorio
			reporte_de_duplicados

			 #  *************************************************************
			 if [ ${SOLO_REGEN_LISTA_FILES_REP[$NUM_REPOS]^^} = "TRUE" ]  #2.2
			 then
				   echo "${FUNCNAME}: TERMINAR= ${SOLO_REGEN_LISTA_FILES_REP[$NUM_REPOS]^^} "
				   exit  # <----------------- Solo generamos la lista y salimos.	             
			 fi #2.2
			#  *************************************************************
		else #3
			echo "$NOM_ABREV: NO se creara listado del repositorio ${REPOSITORIO[$NUM_REPOS]}"
		fi #3
	fi #4 
done

return
}

#! /bin/bash
#------------------------------------------------------------------------------
#	V1.6	21/09/17 16:52:07 Se crea esta funcion en file separado
#								A partir de la version en Gen_list...1.5
#	V1.7	21/10/17 10:47:55 Se modifica tratamiento de DIRECT considerando
#					contenido de variable INSTALL_DIR que se define en el main
#					Este es el directorio desde el cual se importan los modulos
# 					Esta version es primitiva ya que requiere que todos los modulos
#					Residan en INSTALL_DIR
#					MEJORAR algun dia...
#			23/10/17 00:17:48 Resuelto	(?)	
#			24/10/17 19:53:18 Corregido formato de impresion
#
#-------------------------------------------------------------------------------
listar_modulos ()
{
# Listar versiones de los modulos...
																					
LISTA_SRC=$(grep -e 'source' "$0" | grep -v grep | grep -v -e '#.*source.*' | sed -e 's/source //' -e 's/#.*//'  )
for LISTA_MODS in ${LISTA_SRC}
do
	 DIRECT=${LISTA_MODS%/*}
	 if [ ${DIRECT} = '${INSTALL_DIR}' ]
	 then
	   DIRECT=${INSTALL_DIR}
	 fi
	 
#	 echo "DIRECT1" "${DIRECT}"
#	 DIRECT=${DIRECT/\$\{/}
#    DIRECT=${DIRECT/\}/}	
#    echo "DIRECT2" ${DIRECT} ${!DIRECT}
#    DIRECT=${INSTALL_DIR}

	if [ "${DIRECT}" = '.' ]
	then
	  DIRECT=${PWD}
	fi  

	   VERS=${LISTA_MODS##*_}
	   VERS=${VERS%.*} 
	   MOD=${LISTA_MODS##*/}
	   MOD=${MOD%_V*}
	   printf "%-45s %-27s %-6s\n" ${DIRECT} ${MOD}  ${VERS} 
done
printf "\n\n"	
}
#!/bin/bash
# verif_dirs_y_files   v0.4  27/07/17 19:49:14 
#                      v0.5  29/07/17 14:50:09 
#		       v0.6  01/08/17 01:29:21 Se agrega la creacion etc de ARCHIVO_LOG	
#						LISTA_FILES_ESTR_TEMP se genera ordenada
#			v0.7 02/08/17 11:20:26 Se modifica para invocar la funcion de creacion 
# 				del listado del repositorio
#				Se corrigio verificacion de LISTA_FILES_ESTR_TEMP para el script
#				Gen_list_files...	
#                         A corregir: Usar variable COMANDO_COMPLETO...
#				Agregado la impresion del nombre del Directorio_origen a los archivos
#				$ARCHIVO_LOG  $LISTA_FILES_ESTR_TEMP  $LISTA_FILES_NO_COPIAR
#			v0.8 07/08/17 14:07:32 Verica existencia listados para Dir1 y Dir0 para el 
#				script Gen_list_files_cel_NO_copiar
#			   09/08/17 17:01:32 Se agrega -v "$PATRON_DIR_MINIAT_CGATE" a la creacion del 
#					     listado del al estr temporaria
#			V0.81 11/08/17 17:14:14 Se corrige el caso en que la estructura temporal no 
#									contenga archivos, para que no se ejecute el find.
#			        Se usa la variable ${COMANDO_COMPLETO} para determinar que secciones se
#				ejecutaran
#			V1.1 25/08/17 09:40:58 Se crea v1.1. Reordenamiento de secciones
#				crea_listado_rep... pasa al final y se ejecuta siempre.
#				Se cambia la linea "for indice in ${REPOS_A_CONS[@]}" Antes decia "1 0"
#		----->>>>	Se inhibe la ejecucion de esta funcion si se la invoca desde 
#				Gen_list_files_cel_NO_copiar ya que no hay mas listado de repositorio en file.
#           V1.5 11/09/17 13:16:50    Se agrega la creacion de  WORK_SCRIPT_VID
#				18/09/17 15:59:27 Se agrego sha-bang en creacion de  WORK_SCRIPT_VID
#								  Se elimino el touch al crear Lista_files_no_copiar y se agrego un # en 
#									linea directorio_origen		
#								  Se agrega la llamada a listar_modulos, condicional por la variable LISTAR_MODULOS	
# 			V1.6 21/09/17 16:38:54 Se adapta para la version simplificada de Gen_list_files... suprimiendo las secciones
#									de codigo innecesarias.
#			02/10/17 22:22:02 Anulada la creacion de la lista de estr temporaria. Luego habra que modificar 
#							  (Ver notas cuaderno)
#			V1.7 03/10/17 06:52:42 Crea la lista de estr_temp como un array en memoria 
#								   Prevee el caso de que no haya files en la estr_temp
#				09/10/17 12:04:11  Agregada linea para registrar el nombre del dir de la estr temp
#								   al escribir en NO_COPIAR al LOG y al WORK_SCRIPT
#				09/10/17 18:01:03  Agregada la verificacion / creacion de SUB_DIR_NO_COPIAR
#			V1.8 27/10/17 22:56:10 Crea listado repositorio se ejecuta para ambos scipts
#				27/11/17 14:22:29 Se agrego printf de 2 renglones separadores a NO_COPIAR
#				15/01/18 18:29:18 Se modifico string a "Creando Array en Mem de Estr Temp"
#							Se agregaron las marcas de tiempo del array tiempo y se elimino
#							variable simple de tiempo
#	V1.95	15/01/18 19:38:02 Se mueve creacion de log y listado de modulos al principio
#	V2.2	04/06/18 18:47:42 Se prevee el cambio de nombres de los programas a
#								a_et y a_nc
#
#
Verif_dirs_y_files ()
#-------------------------------------------------------------------------
{

# Verificar existencia de directorio de trabajo 
if [ ! -d "$WORK_DIR" ]
then
  echo "$NOM_ABREV: No existe $WORK_DIR"
  exit
fi
#-------------------------------
# Verificar si el tipo de celular especificado es valido
# Agregar Codigo
#-------------------------------



# El script "Gen_list_files_cel_NO_copiar" solo deberia terminar si LISTA_FILES_REP no existe.
# (En este caso tal vez no sea necesario verificar si es accesible el REPOSITORIO.
#
#
# Codigo para verificar listados de Dir1 y Dir0
# en V1.6 se suprime toda esta seccion porque ya no es necesaria

	
#-------------------------------
# El script "Fotos_cel_a_Estr_Temp" debe crear $WORK_DIR/$NOM_CEL si este no existe.

if [ ${COMANDO_COMPLETO} = "Fotos_cel_a_Estr_Temp" ] || [ ${COMANDO_COMPLETO} = "a_et" ]
then
	if [ ! -d $WORK_DIR/$NOM_CEL ]
	then
		if [ -f $WORK_DIR/$NOM_CEL ]
		then
		   echo "$NOM_ABREV: No se puede crear: $WORK_DIR/$NOM_CEL es un archivo"
		   exit
		fi	
		echo "$NOM_ABREV: Creando $WORK_DIR/$NOM_CEL"	
		printf "\n"
		mkdir $WORK_DIR/$NOM_CEL	
	else
	   	echo "$NOM_ABREV: Ya existe $WORK_DIR/$NOM_CEL"
	   	printf "\n"
	fi
fi

# El script "Gen_list_files_cel_NO_copiar" solo deberia terminar si $WORK_DIR/$NOM_CEL no existe.
if [ ${COMANDO_COMPLETO} = "Gen_list_files_cel_NO_copiar" ] || [ ${COMANDO_COMPLETO} = "a_nc" ]
then 
    if [ ! -d $WORK_DIR/$NOM_CEL ]
	then
           echo "$NOM_ABREV: NO existe $WORK_DIR/$NOM_CEL"
           exit
    fi	
fi

#-------------------------------------------------------------------------------
# Si ARCHIVO_LOG no existe, puede ser creado por cualquiera de los 2 scripts
#-------------------------------------------------------------------------------
if [ ! -f "$ARCHIVO_LOG" ]
then
  echo "${NOM_ABREV}: Creando ${ARCHIVO_LOG}"
   
  echo "# Creado por: $0"         				 				>${ARCHIVO_LOG}
else
  echo "${NOM_ABREV}: Ya existe $ARCHIVO_LOG"
  echo "# Agregado por: $0"         							>>${ARCHIVO_LOG}
fi
  echo "${RUN_DATE}"                        					>>${ARCHIVO_LOG}
  echo "# Directorio Origen: ${DIR_FILES_COPIADOS_DEL_CEL}"  	>>${ARCHIVO_LOG}
  echo "# Directorio Estr Temp: ${ESTR_TEMP}"				  	>>${ARCHIVO_LOG}
  echo															>>${ARCHIVO_LOG}

#------------------------------------------------------------------------------------
# No hay alternativa que poner esto aqui ya que antes no estaria creado el ARCHIVO_LOG

if [ ${LISTAR_MODULOS} = "TRUE" ]
then
	listar_modulos  >>${ARCHIVO_LOG}   #--------------------->
fi	
#-------------------------------------------------------------------------------

# El siguiente segmento relacionado con la creacion de $ESTR_TEMP corresponderia solo a
# "Fotos_cel_a_Estr_Temp"; este  script DEBERIA terminar si YA EXISTE y contiene archivos.
# La ESTR_TEMP deberia estar VACIA al final del proceso ya que:

# 	Los Files "interesantes" deberian haber sido movidos al repositorio
# 	Files "NO interesantes"  deberian haber sido eliminados

if [ ${COMANDO_COMPLETO} = "Fotos_cel_a_Estr_Temp" ] || [ ${COMANDO_COMPLETO} = "a_et" ]
then 
	if [ ! -d $ESTR_TEMP ]
	then
	    echo "$NOM_ABREV: No Existe $ESTR_TEMP"
		 if [ -f $ESTR_TEMP ]
		  then
		   echo "$NOM_ABREV: No se puede crear: $ESTR_TEMP es un archivo"
		   exit
		 fi	
		echo "$NOM_ABREV: Creando $ESTR_TEMP"	
		mkdir $ESTR_TEMP	
	else
	  if [ "$(ls -A $ESTR_TEMP)" ] 
	   then
		   echo "$NOM_ABREV: $ESTR_TEMP no debe contener archivos"
		   exit
	   fi
	fi
fi

#-------------------------------------------------------------------------------
# La LISTA_FILES_ESTR_TEMP se creara por el script Gen_list_files_NO_copiar
# Considerando el caso de que no contenga archivos ya que se depuraron todos.
#-------------------------------------------------------------------------------
# Crear array de Estructura temporaria.
# ET_Lista_files  			<--- Lista obtenida con find
# Lista_files_estr_temp		<--- Array indexado de la estr temp ; 
#									la clave es el nombre del arch
#
# ------------------------------------------------------------------------------
# 
if [ ${COMANDO_COMPLETO} = "Gen_list_files_cel_NO_copiar" ] || [ ${COMANDO_COMPLETO} = "a_nc" ] # 1 
then
	if [ ! -d $ESTR_TEMP ] # 2
	then
	    echo "$NOM_ABREV: No Existe $ESTR_TEMP"
	    exit  
	fi # 2

	echo "# ${NOM_ABREV}: Creando Array en Mem de Estr Temp"
	echo "# Directorio Estr Temp: ${ESTR_TEMP}"	
	
	Tinicio_estr_temp=$(date +%s) #Para Gen_list... Ponemos la referencia aqui.# <--- Eliminar

	let TIEMPO[INICIO_ET]=$(date +%s)

	if [ ! "$(ls -A $ESTR_TEMP)" ]  #4
	then 
		# Que no haya archivos es una posiblidad ya que podrian haberse 
		# depurado todos. Continuar
		# Usar un valor dummy para que no falle la logica
		#
		echo "# ${NOM_ABREV}: ${ESTR_TEMP} no contiene archivos" 
		Lista_files_estr_temp["dummy"]="/dummy/dummy"
		echo "# Usando valor: ${Lista_files_estr_temp["dummy"]}"
	else #4 
		echo "$NOM_ABREV: ${ESTR_TEMP} existe y contiene archivos"
	    # Este formato permite descartar los eventuales directorios de 
		# miniaturas en caso en que el WORK_DIR se encontrara en el NAS.
		ET_Lista_files=$(find ${ESTR_TEMP} -type f | grep -v ${PATRON_DIR_MINIAT_CGATE} | sort )

		for ET_full_path_name in ${ET_Lista_files[@]}
		do
			# EL indice_hash es el NOMBRE DEL ARCHIVO; 
			# Eliminar Longest match de todo lo que preceda a /
			# Equivalente a basename, pero mas rapido: Esto lo hace bash...	
			ET_nom_file=${ET_full_path_name##*/}											
			Lista_files_estr_temp[${ET_nom_file}]=${ET_full_path_name}
		done
	   
	fi # 4
	
	let TIEMPO[FIN_ET]=$(date +%s)
	let ACUM_TIEMPOS[ET]=${TIEMPO[FIN_ET]}-${TIEMPO[INICIO_ET]}

fi # 1
#------------------------------------------------------------------------------------
# Si LISTA_FILES_NO_COPIAR no existe, puede ser creado por cualquiera de los 2 scripts
# Antes se verifica que exista el directorio SUB_DIR_NO_COPIAR.
# 
if [ ! -d ${WORK_DIR}"/${SUB_DIR_NO_COPIAR}" ]
then
	echo "${NOM_ABREV}: No existe ${WORK_DIR}/${SUB_DIR_NO_COPIAR}"
    if [ -f ${WORK_DIR}"/${SUB_DIR_NO_COPIAR}" ]
    then
       echo "${NOM_ABREV}: No se puede crear: ${WORK_DIR}/${SUB_DIR_NO_COPIAR} es un archivo"
	   exit
	else	
		echo "${NOM_ABREV}: Creando ${WORK_DIR}/${SUB_DIR_NO_COPIAR}"	
		mkdir "${WORK_DIR}/${SUB_DIR_NO_COPIAR}"
	fi
else
	echo "${NOM_ABREV}: Ya existe ${WORK_DIR}/${SUB_DIR_NO_COPIAR}"
fi		

if [ ! -f "${LISTA_FILES_NO_COPIAR}" ]
then
	  echo "$NOM_ABREV: Creando $LISTA_FILES_NO_COPIAR"
	  
	  echo "# Creado por: $0"         					  >$LISTA_FILES_NO_COPIAR  
else
	  echo "$NOM_ABREV: Ya existe $LISTA_FILES_NO_COPIAR"
	  printf "\n\n"											>>$LISTA_FILES_NO_COPIAR
	  echo "# Agregado por: $0"         					>>$LISTA_FILES_NO_COPIAR  
fi

echo "# ${RUN_DATE}"                        		         >>$LISTA_FILES_NO_COPIAR
echo "# Directorio Origen   : ${DIR_FILES_COPIADOS_DEL_CEL}" >>$LISTA_FILES_NO_COPIAR
echo "# Directorio Estr Temp: ${ESTR_TEMP}"				     >>$LISTA_FILES_NO_COPIAR
printf "\n\n"												 >>$LISTA_FILES_NO_COPIAR

#------------------------------------------------------------------------------------
if [ ${COMANDO_COMPLETO} = "Fotos_cel_a_Estr_Temp" ] || [ ${COMANDO_COMPLETO} = "a_et" ]
then 
	if [ ! -d "$DIR_FILES_COPIADOS_DEL_CEL" ]
	then
	   echo "$NOM_ABREV: No existe $DIR_FILES_COPIADOS_DEL_CEL"
	   if [ -f $DIR_FILES_COPIADOS_DEL_CEL ]
	   then
		   echo "$NOM_ABREV: No se puede crear: $DIR_FILES_COPIADOS_DEL_CEL es un archivo"
		   exit
	   fi	
	   echo "$NOM_ABREV: Creando $DIR_FILES_COPIADOS_DEL_CEL"	
	   mkdir $DIR_FILES_COPIADOS_DEL_CEL
	   echo "Copiar ahora los archivos desde el CEL hacia --> $DIR_FILES_COPIADOS_DEL_CEL"
	   exit
	else   
	   echo "$NOM_ABREV: Ya existe $DIR_FILES_COPIADOS_DEL_CEL"
	   if [ ! "$(ls -A $DIR_FILES_COPIADOS_DEL_CEL)" ] 
	   then
		echo "No se encontraron archivos en:                   $DIR_FILES_COPIADOS_DEL_CEL"       
		echo "Copiar AHORA los archivos desde el CEL hacia --> $DIR_FILES_COPIADOS_DEL_CEL" 
		exit
	   fi
	fi
fi
#------------------------------------------------------------------------------------
if [ ${COMANDO_COMPLETO} = "Gen_list_files_cel_NO_copiar" ] || [ ${COMANDO_COMPLETO} = "a_nc" ]
then			
  if [ ! -d "$DIR_FILES_COPIADOS_DEL_CEL" ]
  then
     echo "$NOM_ABREV: No existe $DIR_FILES_COPIADOS_DEL_CEL"
     exit
  else
       if [ ! "$(ls -A $DIR_FILES_COPIADOS_DEL_CEL)" ] 
       then
          echo "No se encontraron archivos en:    $DIR_FILES_COPIADOS_DEL_CEL"  
          exit
       fi
  fi
fi
#------------------------------------------------------------------------------------
# Creacion del file WORK_SCRIPT_VID
# Solo para Fotos_cel_a_Estr_Temp

if [ ${COMANDO_COMPLETO} = "Fotos_cel_a_Estr_Temp" ] || [ ${COMANDO_COMPLETO} = "a_et" ]
then 
    echo "${NOM_ABREV}: Creando ${WORK_SCRIPT_VID}"
    echo '#! /bin/bash'											>${WORK_SCRIPT_VID}
    echo "# Creado por: $0"         				 			>>${WORK_SCRIPT_VID}
    echo "# ${RUN_DATE}" 										>>${WORK_SCRIPT_VID}
    echo "# Directorio Origen: ${DIR_FILES_COPIADOS_DEL_CEL}" 	>>${WORK_SCRIPT_VID}
    echo "# Directorio Estr Temp: ${ESTR_TEMP}"					>>${WORK_SCRIPT_VID}
    echo														>>${WORK_SCRIPT_VID}
fi


#------------------------------------------------------------------------------------
# Ahora no es un "listado" pero se mantiene el nombre...
#------------------------------------------------------------------------------------

	crea_listado_repositorio     #--------------------> Crear los listados de los repositorios.

#   echo "Cant Elem Array: ${#Lista_files_index[@]}"       | tee -a ${ARCHIVO_LOG}

}


#! /bin/bash

#-------------------------------------------------------------------------
carga_patrones ()
# 1.6 29/12/17 17:16:49 Se cambia en str20 a mayusculas "VIDEO"
# v2.0 24/05/18 21:42:04 Se agregaron patrones str_14 y str_46 
#		27/05/18 00:28:46 Se elimino la extension de tipo en los str_40 ... str_46
#		27/05/18 00:42:38 Se agrego nuevo tipo SMOV en str_47
#-------------------------------------------------------------------------
{
#  Patrones de nombres
#
#  XT910							Prueba 2018-05-25
# 	2013-05-30_20.00.59.jpg					OK
# 	2013-09-09_12-57-51_115.jpg				OK
# 	IMG_20140412_153819_870.jpg				OK
# 	VID_20140518_122024_827.mp4				OK
#  BLU
#  IMG_20161010_100530.jpg					OK
#   Camara de video 20180522010203_010.mjpeg	OK
str_10="IMG_"
str_11="VID_"
str_12="^[0-9]\{4\}\-[0-9]\{2\}\-[0-9]\{2\}"
str_14="^[0-9]\{14\}_010"

#  Samsung viejo
#       2013-07-14 12.50.09.jpg  <-- OJO con el Blanco; Al generar manualmente el archivo      OK
#                 |                     de listado del directorio list_dir_<$NOM_CEL> se debe 
#		  V  			reemplazar el " " por "_"  
#	2013-07-14_12....   		ls -1 | sed -e 's/ /_/' > ${LISTA_FILES_CEL}
#					Esta solucion es chota y sera solucionada mas adelante. 

#       video-2013-02-06-20-56-37.mp4		OK

str_20="VIDEO-"


#  BB
#       IMG00148-20111228-1616.jpg
#	VID-20140420-WA000.mp4

str_30="IMG[0-9]\{5\}-"
str_31="VID-"
str_32="IMG-"

# Considerar tambien los siguientes del Whatsapp:
# IMG-20160201-WA0079.jpeg
# IMG-20160924-WA0000.jpg
#

#  Samsung Young
#
##	VID00006-20111204-2111.jpg <--- No se de donde aparecio
#
# Camara Canon: Estamos en el horno: el formato es 
# 	img_5681.JPG
#       MVI_4115.MOV

# 	la fecha la tenemos que averiguar del archivo
# 	DATE=$(exiftool -p '$DateTimeOriginal' $PICTURE | sed 's/[: ]//g')

#       para los videos
#       mediainfo -f VID-20131224-WA000.mp4 | grep local

#       Esto falla, devolviendo la fecha incorrecta a veces...
#       Volver al esquema original o usar exiftool para los jpg

#       mediainfo -f  IMG00477-20140425-2102.jpg | grep local | sed -r 's/.*([0-9]{4}-)([0-9]{2}-)([0-9]{2}) .*/\1\2\3/'


#str_40="IMG_[0-9]\{4\}\.JPG"
#str_41="MVI_[0-9]\{4\}\.MOV"
#str_42="ST[A-Z]_[0-9]\{4\}\.JPG"
#str_43="DSCN[0-9]\{4\}\.JPG"
#str_44="RSCN[0-9]\{4\}\.JPG"
#str_45="DSCF[0-9]\{4\}\.JPG"
#str_46="CAM[0-9]\{5\}\.JPG"

str_40="IMG_[0-9]\{4\}\."
str_41="MVI_[0-9]\{4\}\."
str_42="ST[A-Z]_[0-9]\{4\}\."
str_43="DSCN[0-9]\{4\}\."
str_44="RSCN[0-9]\{4\}\."
str_45="DSCF[0-9]\{4\}\."
str_46="CAM[0-9]\{5\}\."
str_47="SMOV[0-9]\{4\}\." 

str_patron_gral="${str_10}\|${str_11}\|${str_12}\|${str_14}\|${str_20}\|${str_30}\|${str_31}\|${str_32}"
str_sustit="s/""${str_patron_gral}""//"

return
}
#! /bin/bash

#------------------------------------------------------------------------------
#  v1.5	21/09/17 17:03:05 Creada este archivo separado a partir de Fotos_cel..
#							V1.5
#		22/09/17 12:59:51 Se cambio echo $FNAME por <<<${FNAME}
#		26/09/17 22:08:42 Se agregan contadores de Foto y Video
#		29/12/17 17:10:24 en obtener tipo de pasa FNAME a mayuscula
# 		22/01/18 19:04:32 Se agregaron incrementos de contadores CANT_CANON CANT_GENERAL CANT_OTRA_COSA
#		22/01/18 19:11:10 Se anularon los contadores anteriores
#	V2.1 24/05/18 21:47:00 Se agrego tipo de video mjpeg y str_46
#		27/05/18 00:46:53 Se agrega patron str_47
#------------------------------------------------------------------------------
obtener_extension ()
#------------------------------------------------------------------------------
{
							# Esto parece que funciona aun si el arch no tiene extension...
file_ext="${FNAME##*.}" 	# obtener extension
file_ext="${file_ext,,}" 	# pasar extension a minuscula

# Decidir en base al tipo de extension del archivo si es FOTO o VIDEO

case ${file_ext} in
	bmp |  gif | jpg | jpeg | tiff | png  )
	TIPO_ARCH=FOTO
	let Tipo_Foto++
	;;
    3gp | avi | mov | qt | mpg| mpeg4| mp4 | wav | wmv | divx | mjpeg )
        TIPO_ARCH=VIDEO
        let Tipo_Video++
	;;
    *)   
        TIPO_ARCH=OTROS
    ;;
esac

#  echo "Extension: ${file_ext}  TIPO: ${TIPO_ARCH}"
return
}
#-------------------------------------------------------------------------------
obtener_tipo_archivo () # Determina el tipo de nombre del archivo
						# DSCN  IMG_20170819 etc
						# de acuerdo a los patrones predefinidos
						# para separar los que tiene fecha en el nombre de los
						# que no la tienen.
#-------------------------------------------------------------------------------
{
	
# FNAME="${FNAME^^}"

grep -q -e "$str_40\|$str_41\|$str_42\|$str_43\|$str_44\|$str_45\|$str_46\|$str_47" <<< ${FNAME^^}

if [ $? = "0" ] #2 		# Es tipo CANON?
then
       TIPO_NOM_ARCH="CANON"   
#       let CANT_CANON++
else #2
      grep -q -e "${str_patron_gral}" <<<${FNAME^^}
      if [ $? = "0" ] 	#1	# Es tipo General 
      then
       TIPO_NOM_ARCH="GENERAL"
#       let CANT_GENERAL++
      else  #1
       TIPO_NOM_ARCH="OTRA_COSA" 
#       let CANT_OTRA_COSA++
      fi  #1
fi #2	
	
}
#! /bin/bash
#
#
#	V1.3 03/09/17 22:05:32 Cread0 el file extractando las 2 funciones de la vers 1.2 de Fotos_cel...
#	     04/09/17 08:12:36 Esta version tiene no detecta correctamente si el archivo es el mismo o no
#			  	ya que se descubrio que la misma foto puede tener pequeñas variaciones de 
#				tamaño, por lo cual se deberia comparar las fechas.	
#	V1.4 04/09/17 08:15:03 Esta version pretende corregir el problema de la vers 1.3
#			extractando la fecha completa del archivo del cel y comparando la del cel con la 
#                       del # repositorio
#       V1.5 05/09/17 18:30:56 Se agrega funcion determ_tipo_nom_arch
#	     07/09/17 11:23:49 Se agrega funcion determ_por fecha
#	     08/09/17 09:24:18 Se elimino funcion determ_tipo_nom_arch	
#        12.09.2017 11:39:40 Se agrega la logica para comparar fechas  solo para los archivos CANON y OTRA_COSA
#		17/09/17 21:16:51 Se saca la seccion de determinacion de TIPO_NOM_ARCH, que se convierte en una funcion
# 						  en el main que se ejecuta al comienzo.
#		18/09/17 00:25:57  Se cambia la logica, sacando la fecha del arch del cel solo para CANON y OTRA_COSA
#		18/09/17 16:49:24	Se paso determinacion de FNAME a partir de FNAME_FULL al comienzo del main
#  v1.6 29/09/17 00:38:45 Se cambia totalmente la funcion obtener_fechas por la simple obtener_fecha
#						  	que toma en cuenta los distintos tipos de extension y en base a eso decide que
#							metodo utilizar para extraer la fecha.
#						En buscar en sinonimos se cambian todas las invocaciones de exiftool con sed por
#						llamadas a obtener_fecha
#		25/10/17 00:02:21 Se cambia en determ_por_fecha la regla para los arch de tipo GENERAL
#						  decidiendo que es el mismo arch cuando el tamaño es !=
#		29/10/17 11:28:52 Se modifican los case de obtener_fecha para preveer que exiftool
#					No pueda obtenerla, en cuyo caso devuelve "????"
#		29/10/17 22:28:45 Se agrego un separador de lineas en log
#		10/11/17 19:49:19 Se modifico el echo del caso General de determinar por fecha por
#						"En Repos:"	
#	V1.7 22/11/17 14:52:55 Se anulan todas las lineas que contengan let ESTABA_EN_REPOSIT[$NUM_REPOS]++
#				  ya que la contabilizacion del "estado" se hara en el case del cuerpo principal
#	V1.8 07/01/18 02:06:10 Nueva version, donde se compara por fechas y no por tamaño
#						Se recurre a comparar por tamaño para aquellos casos que no se pueda
#						determinar la fecha y la fecha sea "????"
#						Se agregp la funcion determinar_por_tamano
#	V1.95 11/01/18 10:20:37 Se crea renombrando V1.8, por consistencia (?) con V1.95 de los main
#					12/01/18 13:21:39 se agrego variable NOM_DIR_SHORT y la rutina gen_nom_dir_short
# 		  01/04/18 01:40:49 Revisar lineas en 255 que estan duplicadas en gen_nom_dir_short. Revisar
#	V2.0  27/04/18 11:21:52 Se invoca gen_nom_dir_short y se suprimieron lineas duplicadas
#							Se adapta para manejar repositorio con archivos que vienen de un zip
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#	V1.6	28/09/17 16:10:56 Creada esta funcion
obtener_fecha ()
#-------------------------------------------------------------------------------
{
# Devuelve  2017-04-25_HH:MM:SS

ARCH_P_ANALIZAR=$1

case ${file_ext} in

	bmp | gif | jpeg | png )
		FECHA_ARCH=$(exiftool -q -q  -d '%Y-%m-%d_%H:%M:%S' -p '$FileModifyDate' ${ARCH_P_ANALIZAR})
		if [ ${#FECHA_ARCH} = 0 ]  # Por si el exiftool nos falla... 
		then
			FECHA_ARCH="????"
		fi
	;;
	jpg )
		FECHA_ARCH=$(exiftool -q -q -d '%Y-%m-%d_%H:%M:%S' -p '$DateTimeOriginal' ${ARCH_P_ANALIZAR})
		if [ ${#FECHA_ARCH} = 0 ]  # Por si el exiftool nos falla...
		then
			FECHA_ARCH=$(exiftool -q -q  -d '%Y-%m-%d_%H:%M:%S' -p '$FileModifyDate' ${ARCH_P_ANALIZAR})
			if [ ${#FECHA_ARCH} = 0 ] 
			then
				FECHA_ARCH="????"
			fi
		fi 
    ;;
    tiff )
		FECHA_ARCH="????"
	;;
    3gp)
		FECHA_ARCH=$(exiftool -q -q -d '%Y-%m-%d_%H:%M:%S' -p '$CreateDate' ${ARCH_P_ANALIZAR})
		if [ ${#FECHA_ARCH} = 0 ]  # Por si el exiftool nos falla... 
		then
			FECHA_ARCH="????"
		fi 
	;;
    mov | wav )
		FECHA_ARCH=$(exiftool -q -q -d '%Y-%m-%d_%H:%M:%S' -p '$DateTimeOriginal' ${ARCH_P_ANALIZAR})
		if [ ${#FECHA_ARCH} = 0 ]  # Por si el exiftool nos falla... 
		then
			FECHA_ARCH="????"
		fi 
    ;;
    avi | wmv | divx | mpg | mp4 | mpeg4 )
		FECHA_ARCH="????"
	;;
esac

echo "${FECHA_ARCH}"

return
}


gen_nom_dir_short ()
{
	NOM_DIR_SHORT=${Lista_files_index[${indice_hash}]%/*}  # Elimina file name
	NOM_DIR_SHORT=${NOM_DIR_SHORT##*/}  # Elimina lo que predece la / de mas a la derecha
	NOM_DIR_SHORT=${NOM_DIR_SHORT%%_*}  # Elimina de descripcion del directorio
									    # Queda solo la fecha
	return								    
}
#-------------------------------------------------------------------------------
determinar_por_tamano ()  # 
#-------------------------------------------------------------------------------
{
#
# El tamaño del file que esta en el repositorio se obtiene aca en el caso de que
# no haya sinonimos,
# ya que en el caso de existencia de sinonimos, ya estaria almacenado en el array
#
# Igual a 0 ==> no hay sinonimos ya que no se tuvo que calcular tamaño
# Aca devuelve la long del tamaño, no el tamaño

let Det_por_tamano++

if [ ${#Tam_File[${indice_hash}]} = 0 ] 
then  # Determinar el tamaño
	Tam_File[${indice_hash}]="$(stat -c '%s' ${Lista_files_index[${indice_hash}]} )"
fi

if [ ${Tam_File[${indice_hash}]} = ${Tam_file_cel} ]
then
	EN_REPOS[$NUM_REPOS]=SI
				#	---------> Quitar luego esta linea
	gen_nom_dir_short
	echo "(3)SI REP: $NUM_REPOS Dir: ${NOM_DIR_SHORT} $FNAME"  >> $ARCHIVO_LOG
else
	EN_REPOS[$NUM_REPOS]=NO
	echo "NO en REP $NUM_REPOS:                  $FNAME"  >> $ARCHIVO_LOG
fi
return	
}

#-------------------------------------------------------------------------------
determ_por_fecha ()
{
# Aca se determina si es el mismo archivo comparando las fechas.
# Ya esta determinado el tipo de archivo desde el main:  CANON (DSCN, etc...) o tipo OTROS 

case ${TIPO_NOM_ARCH} in
CANON | OTRA_COSA )             
	# Solo usamos "obtener_fecha" para los arch tipo CANON y OTRA_COSA.
	# Para los archivos de los que no se puede obtener la fecha
	# recurrimos a obtener el tamaño.
	
	if [ ${UNZIPED[${indice_hash}]} = "TRUE" ] # No hay fecha por lo tanto determinar por tamaño
	then
		determinar_por_tamano
		return
	fi
	
	
	Fecha_file_cel="$(obtener_fecha  ${FNAME_FULL} )"
	if [ ${Fecha_file_cel} = "????" ] #2
	then
		determinar_por_tamano
	else #2
		let Det_por_fecha++  		# Contabilizamos para ver realmente cuantos casos de esto hubo
				
			Fecha_File[${indice_hash}]="$(obtener_fecha  ${Lista_files_index[${indice_hash}]} )"
				
		# Aca hay que comparar las fechas para asegurar que es el mismo
		# archivo 
		if [ "${Fecha_File[${indice_hash}]}" = "${Fecha_file_cel}" ] #1
		then
		# Las fechas son iguales ==> misma foto
			EN_REPOS[$NUM_REPOS]="SI"
			gen_nom_dir_short
				 	#	---------> Quitar luego esta linea
			echo "(1)SI REP: $NUM_REPOS Dir: ${NOM_DIR_SHORT} $FNAME"  >> $ARCHIVO_LOG

		else #1
			# Fecha distinta ==> NO es la misma foto
			EN_REPOS[${NUM_REPOS}]="NO"
			gen_nom_dir_short
					# 	---------> Quitar luego esta linea
			echo "(2)NO REP: $NUM_REPOS Dir: ${NOM_DIR_SHORT} $FNAME"  >> $ARCHIVO_LOG

		fi #1
	fi #2 
;;
GENERAL  )
	# Es un archivo tipo GENERAL, por lo cual tendra la fecha en el nombre. 
	# Si los nombres son iguales, y los tamaños son != (cosa poco probable) 
    # (podria pasar por ejemplo si se hiciera un resize de arch en el directorio de origen
	# luego de que este fuera copiado al repositorio)
	# Dejar que mejor decida la unidad de carbono...
	# Unidad de carbono dixit:
	# 25/10/17 00:05:26 repensandolo, definimos que los archivos son el mismo
	# a pesar que el tamaño es distinto
	# 07/01/18 02:34:37 A partir de V1.8 ya no se comparan los tamaños, 
	EN_REPOS[$NUM_REPOS]=SI
								# 	---------> Quitar luego esta linea
	echo "En REP $NUM_REPOS:                  $FNAME"     >> $ARCHIVO_LOG
	
	gen_nom_dir_short			#--------->>>
	
#	echo "En Repos: ${NOM_DIR_SHORT}" >> $ARCHIVO_LOG
	echo "(4)SI REP: ${NUM_REPOS} Dir: ${NOM_DIR_SHORT} ${FNAME}"  >> $ARCHIVO_LOG
;;
esac
return
}
#-------------------------------------------------------------------------------
buscar_en_sinonimos ()
#-------------------------------------------------------------------------------
{
contad=0
SUFIJO='__D'  # Solo comparamos con los duplicados... 

# El contenido de Str_conv_fecha es la expresion de sustitucion para sed
# Definido en carga_parametros

# index=${indice_hash}	# La cantidad de sinonimos esta guardada en el primario.
						# Como hay sinonimos y por eso tenemos un tamaño de archivo
						# en el array
						# para los archivos CANON y OTRA_COSA
						# recorremos los sinonimos comparando fechas
						# mediante determ_por_fecha
						# 
						# para los archivos GENERAL , comparamos solo con el primario

while [  ${#Lista_files_index[${indice_hash}]} != 0  ] 	# Si el slot no esta vacio, comparar
do
	determ_por_fecha   						#--------->>>
    
    if [ ${EN_REPOS[$NUM_REPOS]} = "SI" ]
    then
		return
    fi
    
	let contad++
	# cadena sinonimos. Ejemplo: "Nombrearchivo""__D"1 
	# Aca hacemos XYDir1XYIMG0069.jpg__D8 --> XYDir1XYIMG0069.jpg + "__D" + contador incrementado
	# Esto es porque en determinar por fecha se usa indice_hash
	
	indice_hash=${indice_hash%__D*}${SUFIJO}${contad}
	
#	echo "indice_hash: ${indice_hash}"  
	# podria ser $(( contad++ ))
done

EN_REPOS[$NUM_REPOS]=NO
														# 	---------> Quitar luego esta linea
echo "(5)NO en REP $NUM_REPOS:                       $FNAME"  >> $ARCHIVO_LOG	
return
}

#-------------------------------------------------------------------------------
buscar_en_repositorio ()
{

# Esta en el Repositorio?

									#	---------> Quitar luego esta linea
    printf "\n"   >> $ARCHIVO_LOG   # Un separador de lineas.
    
for NUM_REPOS in "${REPOS_A_CONS[@]}"
do
	indice_hash=${PREFIJO[${NUM_REPOS}]}${FNAME}
	
# Estas lineas estan duplicadas en gen_nom_dir_short. Revisar <<------------	
	
	
#	NOM_DIR_SHORT=${Lista_files_index[${indice_hash}]%/*}  # Elimina file name
#	NOM_DIR_SHORT=${NOM_DIR_SHORT##*/}  # Elimina lo que predece la / de mas a la derecha
#	NOM_DIR_SHORT=${NOM_DIR_SHORT%%_*}  # Elimina de descripcion del directorio
									    # Queda solo la fecha
#	gen_nom_dir_short                   # No debe ir aca, porque si hay sinonimos es incorrecto
    
	
	 # Verificamos primero si esta en Dir1 porque asi es el orden
	 # definido en parametros
    if [ "${#Lista_files_index[${indice_hash}]}" = 0  ]  #4
	then 
		# Slot libre: NO esta en repositorio 
	   	EN_REPOS[$NUM_REPOS]=NO
                                       			#	---------> Quitar luego esta linea
	   	echo "NO en REP $NUM_REPOS:                       $FNAME"  >> $ARCHIVO_LOG
	else #4
	    case ${TAM} in 
	    GT0 )   # Si tamano_file_cel > 0 hacer comparaciones para ver si es el mismo archivo o es otro.
				# Slot ocupado: En repositorio hay algo...
				
#			echo "${Lista_files_index[${indice_hash}]}  ${indice_hash} "
#			echo "indice_hash: ${indice_hash}"
#			echo "Cant sinon: ${REP_CANT_SINON[${indice_hash}]}"

			if [ ${REP_CANT_SINON[${indice_hash}]} -eq 0 ] #3 
			then
				# Igual a 0 ==> no hay sinonimos ya que no se tuvo que calcular tamaño
				# Aca devuelve la long del tamaño, no el tamaño
								
			 	determ_por_fecha						#--------->>>
			else #3 
				# Si <> 0 significa q hay un tamaño almacenado y por ende hay sinonimos.                           	     
		        buscar_en_sinonimos						#--------->>>
			fi #3
		;;
		EQ0 )  	# Si tamano_file_cel EQ0 pero hay un nombre igual en repositorio, 
				# es un caso de informar/revisar
				# No tiene sentido hacer comparaciones de tamaños
			EN_REPOS[$NUM_REPOS]=SI
		 	# Tengo mis dudas de considerarlo valido....
									#	---------> Quitar luego esta linea
			echo "En REP $NUM_REPOS: $FNAME"  >> $ARCHIVO_LOG
	  	;;
		* )
			echo "Paranoia check TAM: ${TAM} valor imposible que no es EQ0 o GT0"
			exit
		;;
		esac
        
	fi #4 
done
return
}

#! /bin/bash

# V1.95 11/01/18 10:26:51 Creada esta version a partir de gen_NC_MEM_V4.5.sh
# 							para incluir en los 2 main.
#		15/05/18 20:37:34 Por las dudas se pasa la extension a minuscula 
#
#
#-----------------------------------------------------------------------------

lee_NC_a_mem ()
{
# Descartamos las lineas con comentarios y las lineas en blanco.
mapfile -t NCM_Lineas <  <( grep -v -e '^#.*' -e '^$' ${LISTA_FILES_NO_COPIAR} )
printf "Cant de Lineas de NC: %4s\n"  ${#NCM_Lineas[@]}


if [ ${#NCM_Lineas[@]} = 0  ]
then  # No hay elementos en el file NC
	NCM_NOMBRE="TRUCHEX"
	NCM_TAM_INDX[${NCM_NOMBRE}]="-1"
	NCM_FECHA_INDX[${NCM_NOMBRE}]="????"
	NCM_SINON_INDX[${NCM_NOMBRE}]=0
	return
fi

let NCM_TOT_LIN=${#NCM_Lineas[@]}-1
let NCM_linecount=0

while [ ${NCM_linecount} -le ${NCM_TOT_LIN} ]
do
	read NCM_NOMBRE NCM_TAM NCM_FECHA NCM_COMMENT <<<${NCM_Lineas[${NCM_linecount}]}
	
	NCM_TIPO_EXTENS=${NCM_NOMBRE##*.}  		# --->>>> Obtener Extension de tipo
   
	NCM_TIPO_EXTENS="${NCM_TIPO_EXTENS,,}" 		# Pasamos a minuscula el tipo de extension para simplificar la lista.
	
	NCM_NOMBRE=${NCM_NOMBRE%.*}"."${NCM_TIPO_EXTENS}  # Sustituimos la extension en minuscula
    
    if [ ${#NCM_TAM_INDX[${NCM_NOMBRE}]}  = 0 ]
	then  # No hay ocupante primario
		NCM_TAM_INDX[${NCM_NOMBRE}]=${NCM_TAM}
		NCM_FECHA_INDX[${NCM_NOMBRE}]=${NCM_FECHA}
		NCM_SINON_INDX[${NCM_NOMBRE}]=0    # Este es el primario, por lo tanto 
										   # el contador de sinonimos es "0"
	else  # Insertar sinonimos
		let NCM_SINON_INDX[${NCM_NOMBRE}]++    # Incrementamos el cont de sinonimos.
		cont=${NCM_SINON_INDX[${NCM_NOMBRE}]}  # Solo para tener una variable mas corta
											   # para el proximo paso
		NCM_TAM_INDX[${NCM_NOMBRE}"__D"${cont}]=${NCM_TAM}
		NCM_FECHA_INDX[${NCM_NOMBRE}"__D"${cont}]=${NCM_FECHA}
	fi
	let NCM_linecount++
done
	
	
	
}

#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
reporta_hallado_en_NC ()
{
if [ ${REPORTA_HALLADO_EN_NC} = "TRUE" ]
then
echo "Del Cel:            ${FNAME} ${Tam_file_cel} ${Fecha_file_cel} ${TIPO_ARCH} ${TIPO_NOM_ARCH} "		>> $ARCHIVO_LOG
echo "En N/C  ${EN_NO_COPIAR} -- ${1} --> ${2} ${NCM_TAM_INDX[${2}]:-N/A} ${NCM_FECHA_INDX[${2}]:-N/A} "   	>> $ARCHIVO_LOG
# printf "\n"
fi

}

#-----------------------------------------------------------------------------
buscar_en_NC_en_mem ()
{

if [ ${#NCM_TAM_INDX[${FNAME}]}  = 0 ]
then
    # Entonces:
	# NO esta en LISTA_FILES_NO_COPIAR
	EN_NO_COPIAR=NO
	reporta_hallado_en_NC 0 "NO_Esta"			#--------->>>#
	
	return
else #3   
	if [ ${Tam_file_cel} = 0 ] #2.2   # Podriamos preguntar ${Tam_file_cel} = 0 
	then
	    # Listo! no sabemos que archivo era, pero ya esta en NO_COPIAR
	    # Seguramente es un archivo que se corrompio en la "media"
	    EN_NO_COPIAR=SI
	    reporta_hallado_en_NC 1 ${FNAME}			#--------->>>#
	    return
	fi  #2.2	
		
    case ${TIPO_NOM_ARCH} in
 	GENERAL ) 
 		# En este caso al ser los nombres iguales consideramos que es el mismo archivo...
 		# ya que la fecha esta en el nombre.
 		# Aca asumimos que es poco probable que haya 2 archivos de contenido totalmente distinto
 		# con la misma fecha a nivel de HH:MM:SS...  
 		EN_NO_COPIAR=SI	
 		reporta_hallado_en_NC 2 ${FNAME}			#--------->>>#
 		return
 		;;
 	CANON | OTRA_COSA )
 		# Ya esta en LISTA_FILES_NO_COPIAR; pero ... ¿Es el mismo archivo?
 		
 		let cont=0
 		SUFIJO=""
 		
 #		set -xv
 		while [ ${cont} -le "${NCM_SINON_INDX[${FNAME}]}" ]
 		do
 		
 			INDEX=${FNAME}"${SUFIJO}"

 				# la Fecha_file_cel ya esta determinada previamente ya que 
 				# se averiguo en buscar_en_repositorio_V1.8 (y posteriores?) 
 				# FALSO lo de arriba: si el file no esta en el repositorio no
 				# se averigua la fecha...
                # El if 1.1 si tiene sentido... 
 				if [ "${Fecha_file_cel}" = "0" ]  #1.1
 				then
# 					echo "Fecha File Cel= ${Fecha_file_cel}  Se deberia averiguar"
 					Fecha_file_cel="$( obtener_fecha ${FNAME_FULL} )" #--------->>>#
 				fi #1.1
             if [ ${Fecha_file_cel} = "????" ] #2.5
	         then
				let Det_por_tamano_en_NC++   # 
				if [ "${Tam_file_cel}" = "${NCM_TAM_INDX[${INDEX}]}" ] #1.4
				then
				  EN_NO_COPIAR=SI
 				  reporta_hallado_en_NC 3 ${INDEX}		#--------->>>#
 				  return
 			    fi #1.4
 			 else #2.5	
 				# echo  "Fecha_cel ""${Fecha_file_cel}"  "NC_FECHA " "${NC_FECHA}"
 				if [ "${Fecha_file_cel}" = "${NCM_FECHA_INDX[${INDEX}]}" ] #1.5
 				then
					let Det_por_fecha_en_NC++
					EN_NO_COPIAR=SI
					reporta_hallado_en_NC 4 ${INDEX}	#--------->>>#
#					set +xv
 					return
 				fi  #1.5	
			fi #2.5
 			let cont++
 			SUFIJO="__D""${cont}"
 		done
		set +xv
		EN_NO_COPIAR=NO
		reporta_hallado_en_NC 5 ${INDEX}		#--------->>>#
	;;
	esac
	
fi #3	


}


#! /bin/bash
#	Version 0.8 07/08/17 18:59:32 Se crea esta funcion en archivo aparte
#		  extractado de Fotos_cel_a_Estr_Temp_V0.8.sh
#		1.2 27/08/17 21:11:20 Se agregan las lineas de reporte de tiempos; 
#		    	28/08/17 20:35:08 Se agrega variable Tinicio
#		    	07/09/17 23:05:05 Se agregan los contadores Tipo_Canon y  Det_por_fecha
#				26/09/17 22:09:14 Se agregan contadores de Foto y Video
#			    03/10/17 00:57:59 Agregado de {} y :-0 
#       1.7 03/10/17 13:39:48 Se hacen 2 variantes en un unico file eliminando
#							las variables que no se usan en 
#                           Gen_list_files_cel_NO_copiar
#                           Se cambia el here document por lineas con printf
#			25/10/17 19:52:30 Se agrego la impresion de variable $AGREGAR_A_ESTR_TEMP
#							y se cambio el orden de impresion
#		1.8	29/10/17 19:54:25 Se adecuaron los reportes al uso de Regla 2 V2.0 en
#							Gen_list_files_NO_copiar_V1.8
#		1.9	27/11/17 10:27:52 Version con matriz de contadores de Estado y eliminacion
#							de impresion de algunos contadores de Estado
#		2.0	05/12/17 21:41:10 Version que incluye el reporte para Gen_list_files_NO_copiar
#			27/05/18 00:04:51 Se agrego al total de acciones +${INF_REV_Y_NO_COPIAR}
#							
#------------------------------------------------------------------------
# Generar REPORTE
#------------------------------------------------------------------------
generar_reporte ()
{
	
printf "\n\n"	
	
if [ ${COMANDO_COMPLETO} = "Fotos_cel_a_Estr_Temp" ]
then	

printf "Generado por     : %s \n" 	$0 
printf "          Reporte: %s \n" 	"${RUN_DATE}"
printf "Directorio Origen: %s \n\n" ${DIR_FILES_COPIADOS_DEL_CEL}

printf "Tiempo generac Estr Temp: %5s seg\n"    $[${Tfin_estr_temp:-0}-${Tinicio_estr_temp:-0}]	
printf "Tiempo total ejecucion  : %5s seg\n\n"  $[${Tfin_estr_temp:-0}-${Tinicio:-0}]

printf "TOT_FILES_DEL_CEL  : %5s\n"   ${TOT_FILES_DEL_CEL}
printf "TOT_ESPUREOS_CEL   : %5s\n\n" ${TOT_ESPUREOS_CEL}

# Reporte de Estado

let TOT_GT0=0
let TOT_EQ0=0

printf "                          GT0                                   EQ0\n"
printf "%-10s       %4s %4s %4s %5s    %6s           %4s %4s %4s %5s\n" "Estado" "REP1" "REP0" "N/C" "CANT" "Estado"  "REP1" "REP0" "N/C" "CANT"

FMT1="%-26b %4s %4s %4s %6s    %-26b %4s %4s %4s %6s\n"
FMT2="%-15s %4s %4s %4s %6s    %-15s %4s %4s %4s %6s\n"

for EN_REPOS_1 in  "SI" "NO"
do
	
	for EN_REPOS_0 in  "NO" "SI" 
	do
		
		for EN_NO_COPIAR in "NO" "SI"
		do
        
		REGLA_GT0="GT0_${EN_REPOS_1}_${EN_REPOS_0}_${EN_NO_COPIAR}"
		REGLA_EQ0="EQ0_${EN_REPOS_1}_${EN_REPOS_0}_${EN_NO_COPIAR}"
		
		let TOT_GT0=${TOT_GT0}+${CONT_ESTADO[${REGLA_GT0}]:-0}
		let TOT_EQ0=${TOT_EQ0}+${CONT_ESTADO[${REGLA_EQ0}]:-0}
		
		case ${COLORES} in 
			TRUE )
			printf "${FMT1}"	"${TITULO_F[${REGLA_GT0}]:---N/D---}"  \
								${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR} ${CONT_ESTADO[${REGLA_GT0}]:-0}  \
								"${TITULO_F[${REGLA_EQ0}]:---N/D---}" 	\
								${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR}  ${CONT_ESTADO[${REGLA_EQ0}]:-0}
			;;
			FALSE )
			printf "${FMT2}"	"${TITULO_F_NC[${REGLA_GT0}]}"  \
								${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR} ${CONT_ESTADO[${REGLA_GT0}]:-0}  \
								"${TITULO_F_NC[${REGLA_EQ0}]}" 	\
								${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR}  ${CONT_ESTADO[${REGLA_EQ0}]:-0}
			;;
		esac
		
		done
	done
done


printf  "\n%27s   %7s    %29s %7s\n\n" "TOT_GT0=" ${TOT_GT0} "TOT_EQ0=" ${TOT_EQ0}


# Reporte de Acciones

printf "AGREGAR A ESTR TEMP: %5s\n"   ${AGR_A_ESTR_TEMP}
printf "NO ACCION          : %5s\n"   ${NO_ACCION}
printf "AGR_A_NO_COPIAR    : %5s\n"   ${AGR_A_NO_COPIAR}
printf "INFORMAR REVISAR   : %5s\n"   ${INF_REV}
printf "INF_REV_Y_NO_COPIAR:           %5s\n"   ${INF_REV_Y_NO_COPIAR}
printf "              Total= %5s\n\n" $[${AGR_A_ESTR_TEMP}+${NO_ACCION}+${AGR_A_NO_COPIAR}+${INF_REV}+${INF_REV_Y_NO_COPIAR}]

# printf "ESTABA_EN_REPOSIT 1: %5s\n"   ${ESTABA_EN_REPOSIT[1]}  #<----------- Remover Luego?
# printf "ESTABA_EN_REPOSIT 0: %5s\n\n" ${ESTABA_EN_REPOSIT[0]}  #<----------- Remover Luego?

# printf "EN_AMBOS_REP       : %5s\n"   ${EN_AMBOS_REP}
# printf "ESTABA_EN_ESTR_TEMP: %5s\n"   ${ESTABA_EN_ESTR_TEMP}
# printf "ESTABA_EN_NO_COPIAR: %5s\n"   ${ESTABA_EN_NO_COPIAR}
# printf "EQ0_Y_EN_REP       : %5s\n\n" ${EQ0_Y_EN_REP}

# printf "TAM_EQ0            : %5s\n"   ${TAM_EQ0} #<----------- Remover Luego?
# printf "TAM_GT0            : %5s\n\n" ${TAM_GT0} #<----------- Remover Luego?

# Resumen tipos y casos

printf "TOT Tipo Foto      : %5s\n"	  ${Tipo_Foto}
printf "TOT Tipo Video     : %5s\n\n" ${Tipo_Video}

printf "TOT Casos Canon	   : %5s\n"		${Tipo_Canon}
printf "TOT Casos General  : %5s\n"		${Tipo_General}
printf "TOT Casos Otra_cosa: %5s\n\n"	${Tipo_Otra_Cosa}
printf "TOT Det por fecha  : %5s\n\n"	${Det_por_fecha}

fi

#------------------------------------------------------------------------

if [ ${COMANDO_COMPLETO} = "Gen_list_files_cel_NO_copiar" ] # 1 
then
printf "Generado por     : %s \n" 	$0 
printf "          Reporte: %s \n" 	"${RUN_DATE}"
printf "Directorio Origen: %s \n\n" ${DIR_FILES_COPIADOS_DEL_CEL}

printf "Tiempo generac Estr Temp: %5s seg\n"    $[${Tfin_estr_temp:-0}-${Tinicio_estr_temp:-0}]	
printf "Tiempo total ejecucion  : %5s seg\n\n"  $[${Tfin_estr_temp:-0}-${Tinicio:-0}]

printf "TOT_FILES_DEL_CEL  : %5s\n"   ${TOT_FILES_DEL_CEL}
printf "TOT_ESPUREOS_CEL   : %5s\n\n" ${TOT_ESPUREOS_CEL}

let TOT_GT0=0
let TOT_EQ0=0

printf "                          GT0                                   EQ0\n"
printf "%-10s      %3s %3s %3s %3s %5s  %-10s      %3s %3s %3s %3s %5s\n" "Estado" "R1" "R0" "N/C" "E/T" "CANT" "Estado" "R1" "R0" "N/C" "E/T" "CANT"
FMT1="%-26b %3s %3s %3s %3s %6s %-26b %3s %3s %3s %3s %6s\n"
FMT2="%-15s %3s %3s %3s %3s %6s %-15s %3s %3s %3s %3s %6s\n"

for EN_REPOS_1 in  "SI" "NO"
do
	
	for EN_REPOS_0 in  "NO" "SI" 
	do
		
	 for EN_NO_COPIAR in "NO" "SI"
	 do
      for EN_ESTR_TEMP in "NO" "SI"
	  do
		REGLA_GT0="GT0_${EN_REPOS_1}_${EN_REPOS_0}_${EN_NO_COPIAR}_${EN_ESTR_TEMP}"
		REGLA_EQ0="EQ0_${EN_REPOS_1}_${EN_REPOS_0}_${EN_NO_COPIAR}_${EN_ESTR_TEMP}"
		
		let TOT_GT0=${TOT_GT0}+${CONT_ESTADO[${REGLA_GT0}]:-0}
		let TOT_EQ0=${TOT_EQ0}+${CONT_ESTADO[${REGLA_EQ0}]:-0}

		case ${COLORES} in 
		TRUE )
		printf "${FMT1}"	"${TITULO_G[${REGLA_GT0}]}"  \
							${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR} ${EN_ESTR_TEMP} ${CONT_ESTADO[${REGLA_GT0}]:-0}  \
							"${TITULO_G[${REGLA_EQ0}]}" 	\
							${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR} ${EN_ESTR_TEMP} ${CONT_ESTADO[${REGLA_EQ0}]:-0} 
		;;
		FALSE )
		printf "${FMT2}"	"${TITULO_G_NC[${REGLA_GT0}]}"  \
							${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR} ${EN_ESTR_TEMP} ${CONT_ESTADO[${REGLA_GT0}]:-0}  \
							"${TITULO_G_NC[${REGLA_EQ0}]}" 	\
							${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR} ${EN_ESTR_TEMP} ${CONT_ESTADO[${REGLA_EQ0}]:-0} 		
		;;
		esac
	   done
	  done
	done
done

printf  "\n%27s    %7s  %29s %7s\n" "TOT_GT0=" ${TOT_GT0} "TOT_EQ0=" ${TOT_EQ0}

printf "NO ACCION          : %5s\n"   ${NO_ACCION}
printf "AGR_A_NO_COPIAR    : %5s\n"   ${AGR_A_NO_COPIAR}
printf "INFORMAR REVISAR   : %5s\n"   ${INF_REV}
printf "INF_REV_Y_NO_COPIAR:           %5s\n"   ${INF_REV_Y_NO_COPIAR}
printf "              Total= %5s\n\n" $[${AGR_A_ESTR_TEMP}+${NO_ACCION}+${AGR_A_NO_COPIAR}+${INF_REV}+${INF_REV_Y_NO_COPIAR}]

# printf "ESTABA_EN_REPOSIT 1: %5s\n"   ${ESTABA_EN_REPOSIT[1]}
# printf "ESTABA_EN_REPOSIT 0: %5s\n\n" ${ESTABA_EN_REPOSIT[0]}

# printf "EN_AMBOS_REP       : %5s\n"   ${EN_AMBOS_REP}
# printf "ESTABA_EN_ESTR_TEMP: %5s\n"   ${ESTABA_EN_ESTR_TEMP}
# printf "ESTABA_EN_NO_COPIAR: %5s\n"   ${ESTABA_EN_NO_COPIAR}
# printf "EQ0_Y_EN_REP       : %5s\n\n" ${EQ0_Y_EN_REP}

# printf "TAM_EQ0            : %5s\n"   ${TAM_EQ0}
# printf "TAM_GT0            : %5s\n\n" ${TAM_GT0}

printf "TOT Tipo Foto      : %5s\n"	  ${Tipo_Foto}
printf "TOT Tipo Video     : %5s\n\n" ${Tipo_Video}

fi
return
}


#! /bin/bash



reporte_t_parc ()
{

printf "REPORTE DE Tiempos Parciales \n\n"

printf "%-35s:  %6s\n" "Verif_dirs_y_files:"  ${ACUM_TIEMPOS[Verif_dirs_y_files]}

printf "%-35s:  %6s\n" "ACUM_TIEMPOS ET"    ${ACUM_TIEMPOS[ET]}

printf "%-35s:  %6s\n" "ACUM_TIEMPOS FILES_DEL_CEL" ${ACUM_TIEMPOS[FILES_DEL_CEL]}

printf "%-35s:  %6s\n" "ACUM_TIEMPOS FULL" ${ACUM_TIEMPOS[FULL]}

printf "%-35s:  %6s\n\n" "TIEMPO TOTAL" $[${ACUM_TIEMPOS[Verif_dirs_y_files]}+${ACUM_TIEMPOS[ET]}+${ACUM_TIEMPOS[FILES_DEL_CEL]}+${ACUM_TIEMPOS[FULL]}]


printf "%-36b:  %6s\n" "ACUM_TIEMPOS Determ Tamaño" ${ACUM_TIEMPOS[TAM]}

printf "%-35s:  %6s\n" "ACUM_TIEMPOS BUSCAR en REP" ${ACUM_TIEMPOS[BUSCAR_EN_REP]}

printf "%-35s:  %6s\n\n" "ACUM_TIEMPOS Buscar en NO COPIAR" ${ACUM_TIEMPOS[NO_COPIAR]}


return
}
#!/bin/bash
# Version:
#         0.6 01/08/17 11:48:58  Creado este file, copiando de Gen_list...V0.6
#	  0.8 07/08/17 14:41:03  Agregado de contadores para Dir0 y Dir1
#			Se agrego variable EN_AMBOS_REP y INF_REV_Y_NO_COPIAR
#	      24/08/17 23:24:52  Se agrego declare -A Lista_files_index; 
#	      25/08/17 18:28:47 se pone como comentario
#	  1.1 25/08/17 21:37:41 Deja de ser una funcion para ser un "include"
#                               Se agrega definicion de arrays:  Lista_files_index  Tam_file
#          	04/09/17 10:50:38 Se agrega array asociativo Fecha_File
#	       	07/09/17 22:57:33 Se agrega la variable Det_por_fecha
#	       	10/09/17 12:52:42 Se agrega variable TOT_ESPUREOS_CEL
#	       	11/09/17 12:33:01 Se agregan variables   Tipo_Canon Tipo_General Tipo_Otra_Cosa
#			15/09/17 11:23:37 Se agrega la inicializacion en "NO"
#			22/09/17 01:15:59 Se agrega array indexado Lista_files_estr_temp
#			26/09/17 22:08:42 Se agregan contadores de Foto y Video
#     1.7	04/10/17 20:54:58 Se agregan variables para Lista files NO COPIAR en memoria
#							  NO IMPLEMENTADO as of 28/11/17 00:25:44
# 	1.8		22/11/17 15:16:33 Se agregan nuevos contadores como EN_AMBOS_REP_Y_NO_COPIAR		 
#			26/11/17 13:51:54 Se agrega array CONT_ESTADO, que contedra el conteo de todos los casos.
#			27/11/17 11:20:54 Se agregan los arrays de titulos para la impresion de reportes de estado
#							  Se agrega la lista de colores y las matrices con colores y sin colores
#	1.9		05/12/17 21:34:18 Se agregan arrays para Gen_list_files_NO_copiar
#	1.91	06/12/17 12:43:30 Se agregaron arrays para computo tiempos
#			08/01/18 11:10:30 Se agrego la variable del contador Det_por_tamano
#			09/01/18 12:24:14 Se agregaron las variables  Det_por_fecha_en_NC Det_por_tamano_en_NC
#			22/01/18 19:02:31 Se agrego declare -iA CANT_CANON CANT_GENERAL CANT_OTRA_COSA
#	2.0		16/04/18 13:01:38 Se agregan variables REP_CANT_SINON
#			23/04/18 15:38:47 Se agregan variables UNZIPED Z_TOT_FILES Z_TOT_ESPUREOS
#			12/05/18 22:14:18 Se agrego REP_CANT_COP



# inicializar_contadores

# Contadores en cero.

#  declare -i TOT_FILES_DEL_CEL=0

let INF_REV=0
let INF_REV_Y_NO_COPIAR=0
let NO_ACCION=0
let AGR_A_ESTR_TEMP=0
let AGR_A_NO_COPIAR=0

let TAM_EQ0=0
let TAM_GT0=0

let ESTABA_EN_NO_COPIAR=0
let ESTABA_EN_ESTR_TEMP=0

let EN_AMBOS_REP=0
let EN_AMBOS_REP_Y_NO_COPIAR=0

declare -a EN_REPOS=(NO NO)      	# Previendo que solo usemos 1 repositorio, para evitar que la "regla" falle
declare -ai ESTABA_EN_REPOSIT=(0 0)



declare -A Lista_files_index  # Los indices seran ${PREFIJO[$NUM_REPOS]}${FNAME}
declare -A Tam_File
declare -A Fecha_File
declare -iA REP_CANT_SINON     # La cantidad de sinonimos (Duplicados) encontrados para ese FNAME
declare -iA REP_CANT_COP		# La cantidad de Copias encontradas para ese FNAME

declare -A UNZIPED			   # TRUE  si el arch estaba en un zip (o FALSE)
declare -i Z_TOT_FILES
declare -i Z_TOT_ESPUREOS


declare -A Lista_files_estr_temp

let EQ0_Y_EN_REP=0

# No se usan por limitacion del case.
# EXT_TIPO_VIDEO='WAV | wav | 3gp | AVI | avi | MOV | mov | mp4' 
# EXT_TIPO_FOTO='jpg | jpeg'

let Tipo_Foto=0
let Tipo_Video=0

let Tipo_Canon=0        
let Tipo_General=0
let Tipo_Otra_Cosa=0

let Det_por_fecha=0       # Contabilizamos para ver realmente cuantos casos de esto hubo
let Det_por_tamano=0

let Det_por_fecha_en_NC=0
let Det_por_tamano_en_NC=0

let TOT_ESPUREOS_CEL=0

# Array para el computo de tiempos

declare -iA TIEMPO
declare -iA ACUM_TIEMPOS


# Para Lista_files_No_Copiar en array
declare -a NCM_Lineas 
declare -a NCM_Lin_pru  # Solo para la prueba de concepto --->> ELIMINAR
declare -i NCM_linecount NCM_TOT_LIN
declare -A NCM_TAM_INDX NCM_FECHA_INDX 
declare -iA NCM_SINON_INDX

# Colores para impresion

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

# Matriz de contadores de Estado

declare -a EN_REPOS=(NO NO)

declare -iA CONT_ESTADO
declare -iA CANT_CANON CANT_GENERAL CANT_OTRA_COSA

declare -A TITULO_F           # Titulos para Fotos_cel_a_Est_Temp
declare -A TITULO_F_NC

declare -A TITULO_G			  # Titulos para Gen_list_files_cel_NO_copiar
declare -A TITULO_G_NC

# Definir colores

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

# Para Fotos_Cel_a_Estr_Temp

# TITULOS para la matriz de contadores de ESTADO
# Con los Colores

TITULO_F[GT0_SI_NO_NO]="${GREEN}En Rep1${NORMAL}"
TITULO_F[GT0_NO_SI_NO]="${GREEN}En Rep0${NORMAL}"
TITULO_F[GT0_NO_NO_SI]="${GREEN}En N/C ${NORMAL}"
TITULO_F[GT0_SI_SI_NO]="${YELLOW}En Ambos Rep${NORMAL}"
TITULO_F[GT0_SI_NO_SI]="${YELLOW}En Rep1 y N/C${NORMAL}"
TITULO_F[GT0_NO_SI_SI]="${YELLOW}En Rep0 y N/C${NORMAL}"
TITULO_F[GT0_SI_SI_SI]="${RED}-->CASO ANOMALO${NORMAL}"
TITULO_F[GT0_NO_NO_NO]="${GREEN}En NINGUN lado${NORMAL}"

TITULO_F[EQ0_SI_NO_NO]="${YELLOW}En Rep1${NORMAL}"
TITULO_F[EQ0_NO_SI_NO]="${YELLOW}En Rep0${NORMAL}"
TITULO_F[EQ0_NO_NO_SI]="${GREEN}En N/C ${NORMAL}"
TITULO_F[EQ0_SI_SI_NO]="${YELLOW}En Ambos Rep${NORMAL}"
TITULO_F[EQ0_SI_NO_SI]="${YELLOW}En Rep1 y N/C${NORMAL}"
TITULO_F[EQ0_NO_SI_SI]="${YELLOW}En Rep0 y N/C${NORMAL}"
TITULO_F[EQ0_SI_SI_SI]="${RED}-->CASO ANOMALO${NORMAL}"
TITULO_F[EQ0_NO_NO_NO]="${GREEN}En NINGUN lado${NORMAL}"

# Sin los colores

TITULO_F_NC[GT0_SI_NO_NO]="En Rep1"
TITULO_F_NC[GT0_NO_SI_NO]="En Rep0"
TITULO_F_NC[GT0_NO_NO_SI]="En N/C "
TITULO_F_NC[GT0_SI_SI_NO]="En Ambos Rep"
TITULO_F_NC[GT0_SI_NO_SI]="En Rep1 y N/C"
TITULO_F_NC[GT0_NO_SI_SI]="En Rep0 y N/C"
TITULO_F_NC[GT0_SI_SI_SI]="-->CASO ANOMALO"
TITULO_F_NC[GT0_NO_NO_NO]="En NINGUN lado"

TITULO_F_NC[EQ0_SI_NO_NO]="En Rep1"
TITULO_F_NC[EQ0_NO_SI_NO]="En Rep0"
TITULO_F_NC[EQ0_NO_NO_SI]="En N/C "
TITULO_F_NC[EQ0_SI_SI_NO]="En Ambos Rep"
TITULO_F_NC[EQ0_SI_NO_SI]="En Rep1 y N/C"
TITULO_F_NC[EQ0_NO_SI_SI]="En Rep0 y N/C"
TITULO_F_NC[EQ0_SI_SI_SI]="-->CASO ANOMALO"
TITULO_F_NC[EQ0_NO_NO_NO]="En NINGUN lado"

#-------------------------------------------------------------------------------
# Para Gen_List_Files_NO_Copiar

# Con los Colores

# Regla2 V2.0
# TAM GT0
# CONT  EN_REPOS1 EN_REPOS0  EN_NO_COPIAR EN_ESTR_TEMP ACCION      
# 1         SI      NO          NO          NO			NADA      	<- Fue copiado antes
# 2         SI      NO          NO          SI       	INFORMAR <- !!! Es un error !!!
# 3         SI      NO          SI          NO       	INFORMAR <- !!! Es un error !!!
# 4         SI      NO          SI          SI       	INFORMAR <- !!! Es un error !!!

# 5         SI      SI          NO          NO       	INFORMAR    !!! Es un error !!!	<- EN_AMBOS_REP
# 6         SI      SI          NO          SI       	INFORMAR <- !!! Es un error !!! <- EN_AMBOS_REP
# 7         SI      SI          SI          NO       	INFORMAR <- !!! Es un error !!! <- EN_AMBOS_REP
# 8         SI      SI          SI          SI       	INFORMAR <- !!! Es un error !!!	<- EN_AMBOS_REP

# 9          NO      NO          NO          NO  --->   Agregar a N/C 	<-fue eliminado de Es/Temp
# 10         NO      NO          NO          SI         NADA       	<- Se movera a REPOS 1 o 0
# 11         NO      NO          SI          NO       	NADA       	<- Fue marcado N/C antes
# 12         NO      NO          SI          SI       	INFORMAR<- !!! Es un error !!!

# 13         NO      SI          NO          NO       	NADA       	<- Fue copiado antes
# 14         NO      SI          NO          SI       	INFORMAR <- !!! Es un error !!!
# 15         NO      SI          SI          NO       	INFORMAR <- !!! Es un error !!!
# 16         NO      SI          SI          SI 		INFORMAR <- !!! Es un error !!!

TITULO_G[GT0_SI_NO_NO_NO]="${GREEN}En Rep1${NORMAL}"
TITULO_G[GT0_SI_NO_NO_SI]="${RED}-->CASO ANOMALO${NORMAL}"
TITULO_G[GT0_SI_NO_SI_NO]="${RED}-->CASO ANOMALO${NORMAL}"
TITULO_G[GT0_SI_NO_SI_SI]="${RED}-->CASO ANOMALO${NORMAL}"

TITULO_G[GT0_SI_SI_NO_NO]="${YELLOW}En Ambos Rep${NORMAL}"
TITULO_G[GT0_SI_SI_NO_SI]="${RED}-->CASO ANOMALO${NORMAL}"
TITULO_G[GT0_SI_SI_SI_NO]="${RED}-->CASO ANOMALO${NORMAL}"
TITULO_G[GT0_SI_SI_SI_SI]="${RED}-->CASO ANOMALO${NORMAL}"

TITULO_G[GT0_NO_NO_NO_NO]="${GREEN}En NINGUN lado${NORMAL}"
TITULO_G[GT0_NO_NO_NO_SI]="${GREEN}En Es/Temp${NORMAL}"
TITULO_G[GT0_NO_NO_SI_NO]="${GREEN}En N/C ${NORMAL}"
TITULO_G[GT0_NO_NO_SI_SI]="${RED}-->CASO ANOMALO${NORMAL}"

TITULO_G[GT0_NO_SI_NO_NO]="${GREEN}En Rep0${NORMAL}"
TITULO_G[GT0_NO_SI_NO_SI]="${RED}-->CASO ANOMALO${NORMAL}"
TITULO_G[GT0_NO_SI_SI_NO]="${RED}-->CASO ANOMALO${NORMAL}"
TITULO_G[GT0_NO_SI_SI_SI]="${RED}-->CASO ANOMALO${NORMAL}"

   
# Regla2 V2.0
# TAM EQ0
# CONT  EN_REPOS1 EN_REPOS0  EN_NO_COPIAR EN_ESTR_TEMP          
# 1         SI      NO          NO          NO          Agregar a NO COPIAR; Reportar; Verif TAM en Repos? 
#														Posiblemente archivo que se corrompio en cel
# 2         SI      NO          NO          SI          INFORMAR <- !!! Es un error !!!
# 3         SI      NO          SI          NO          INFORMAR <- !!! Es un error !!! (????)
# 4         SI      NO          SI          SI          INFORMAR <- !!! Es un error !!!

# 5         SI      SI          NO          NO          INFORMAR 	<- EN_AMBOS_REP 
# 6         SI      SI          NO          SI          INFORMAR <- !!! Es un error !!!
# 7         SI      SI          SI          NO          INFORMAR 	<- EN_AMBOS_REP Se corrompio en cel
#														y ya se agrego a N/C
# 8         SI      SI          SI          SI          INFORMAR <- !!! Es un error !!!

# 9         NO      NO          NO          NO  --->    Agregar a N/C    
# 10         NO      NO          NO          SI         INFORMAR <- !!! Es un error !!!
# 11         NO      NO          SI          NO         NADA <-- Fue marcado N/C antes
# 12         NO      NO          SI          SI         INFORMAR <- !!! Es un error !!!

# 13         NO      SI          NO          NO         Agregar a NO COPIAR; Reportar; Verif TAM en Repos? 
#														Posiblemente archivo que se corrompio en cel
# 14         NO      SI          NO          SI         INFORMAR <- !!! Es un error !!!
# 15         NO      SI          SI          NO         INFORMAR <- !!! Es un error !!!  (????)       
# 16         NO      SI          SI          SI         INFORMAR <- !!! Es un error !!!
#

TITULO_G[EQ0_SI_NO_NO_NO]="${YELLOW}En Rep1${NORMAL}"
TITULO_G[EQ0_SI_NO_NO_SI]="${RED}-->CASO ANOMALO${NORMAL}"
TITULO_G[EQ0_SI_NO_SI_NO]="${RED}-->CASO ANOMALO${NORMAL}"
TITULO_G[EQ0_SI_NO_SI_SI]="${RED}-->CASO ANOMALO${NORMAL}"

TITULO_G[EQ0_SI_SI_NO_NO]="${YELLOW}En Ambos Rep${NORMAL}"
TITULO_G[EQ0_SI_SI_NO_SI]="${RED}-->CASO ANOMALO${NORMAL}"
TITULO_G[EQ0_SI_SI_SI_NO]="${RED}-->CASO ANOMALO${NORMAL}"
TITULO_G[EQ0_SI_SI_SI_SI]="${RED}-->CASO ANOMALO${NORMAL}"

TITULO_G[EQ0_NO_NO_NO_NO]="${GREEN}En NINGUN lado${NORMAL}"
TITULO_G[EQ0_NO_NO_NO_SI]="${RED}-->CASO ANOMALO${NORMAL}"
TITULO_G[EQ0_NO_NO_SI_NO]="${GREEN}En N/C ${NORMAL}"
TITULO_G[EQ0_NO_NO_SI_SI]="${RED}-->CASO ANOMALO${NORMAL}"

TITULO_G[EQ0_NO_SI_NO_NO]="${YELLOW}En Rep0${NORMAL}"
TITULO_G[EQ0_NO_SI_NO_SI]="${RED}-->CASO ANOMALO${NORMAL}"
TITULO_G[EQ0_NO_SI_SI_NO]="${RED}-->CASO ANOMALO${NORMAL}"
TITULO_G[EQ0_NO_SI_SI_SI]="${RED}-->CASO ANOMALO${NORMAL}"


# Sin los colores

# GT0

TITULO_G_NC[GT0_SI_NO_NO_NO]="En Rep1"
TITULO_G_NC[GT0_SI_NO_NO_SI]="-->CASO ANOMALO"
TITULO_G_NC[GT0_SI_NO_SI_NO]="-->CASO ANOMALO"
TITULO_G_NC[GT0_SI_NO_SI_SI]="-->CASO ANOMALO"

TITULO_G_NC[GT0_SI_SI_NO_NO]="En Ambos Rep"
TITULO_G_NC[GT0_SI_SI_NO_SI]="-->CASO ANOMALO"
TITULO_G_NC[GT0_SI_SI_SI_NO]="-->CASO ANOMALO"
TITULO_G_NC[GT0_SI_SI_SI_SI]="-->CASO ANOMALO"

TITULO_G_NC[GT0_NO_NO_NO_NO]="En NINGUN lado"
TITULO_G_NC[GT0_NO_NO_NO_SI]="En Es/Temp"
TITULO_G_NC[GT0_NO_NO_SI_NO]="En N/C "
TITULO_G_NC[GT0_NO_NO_SI_SI]="-->CASO ANOMALO"

TITULO_G_NC[GT0_NO_SI_NO_NO]="En Rep0"
TITULO_G_NC[GT0_NO_SI_NO_SI]="-->CASO ANOMALO"
TITULO_G_NC[GT0_NO_SI_SI_NO]="-->CASO ANOMALO"
TITULO_G_NC[GT0_NO_SI_SI_SI]="-->CASO ANOMALO"

# EQ0

TITULO_G_NC[EQ0_SI_NO_NO_NO]="En Rep1"
TITULO_G_NC[EQ0_SI_NO_NO_SI]="-->CASO ANOMALO"
TITULO_G_NC[EQ0_SI_NO_SI_NO]="-->CASO ANOMALO"
TITULO_G_NC[EQ0_SI_NO_SI_SI]="-->CASO ANOMALO"

TITULO_G_NC[EQ0_SI_SI_NO_NO]="En Ambos Rep"
TITULO_G_NC[EQ0_SI_SI_NO_SI]="-->CASO ANOMALO"
TITULO_G_NC[EQ0_SI_SI_SI_NO]="-->CASO ANOMALO"
TITULO_G_NC[EQ0_SI_SI_SI_SI]="-->CASO ANOMALO"

TITULO_G_NC[EQ0_NO_NO_NO_NO]="En NINGUN lado"
TITULO_G_NC[EQ0_NO_NO_NO_SI]="-->CASO ANOMALO"
TITULO_G_NC[EQ0_NO_NO_SI_NO]="En N/C "
TITULO_G_NC[EQ0_NO_NO_SI_SI]="-->CASO ANOMALO"

TITULO_G_NC[EQ0_NO_SI_NO_NO]="En Rep0"
TITULO_G_NC[EQ0_NO_SI_NO_SI]="-->CASO ANOMALO"
TITULO_G_NC[EQ0_NO_SI_SI_NO]="-->CASO ANOMALO"
TITULO_G_NC[EQ0_NO_SI_SI_SI]="-->CASO ANOMALO"
#!/bin/bash

echo "kakita"


exit
