#!/bin/bash
# Version:    	0.1 24/07/17 00:52:57 
#               0.4 29/07/17 10:57:34 
#               0.45   29/07/17 14:42:47 Agregado el source de verif_dirs... y eliminando lineas       
# 		0.5  30/07/17 00:29:13  Nueva Regla 2
#               0.55 31/07/17 19:06:58  Modificada la logica para TAM=EQ0 para probar impresion reporte
#               0.58 31/07/17 23:29:52  depuradas lineas de impresion intermedias Correccion sumas
#                                       Extension de reglas para EQ0
#               0.6  01/08/17 00:16:38  Mas depuracion lineas intermedias impresion
#					Invoca los parametros y verif_dirs 0.6 que incluyen ARCHIVO_LOG
#					El reporte es generado con un here document
#					carga inicializar contadores V0.6         OK
#		0.7 04/08/17 16:23:48   Carga sources version 0.7
#                                       invoca funciones acorde a version 0.7
#					Se filtran los directorios de miniaturas, por si
#					los files del cel se copian al NAS.
#		0.8 09/08/17 00:02:28   Se incluyen versiones 0.8 de los source
#				Los componentes de la REGLA se separan con "_" para mayor legibilidad
#				La Regla 2 V2.0 se extiende para considerar Rep1 y Rep0	
#				Se agrega procesamiento de los 2 repositorios
#				Se agrega tee -a en informar_revisar
#		   11/08/17 17:16:03  Se carga la vers 0.81 de verif_dirs_y_files
#		1.3 31/08/17 11:03:00 Version no publicada. Es para adaptar a estructuras rep en mem
#		1.5	21/09/17 16:33:16 Version adaptada a las nuevas estructuras y nuevas funciones
#			21/09/17 16:54:38 Se agrega source de listar_modulos_V1.5 
#			22/09/17 13:26:13 Se agrega source de carga_patrones_V1.6 
#			01/10/17 22:11:07 Se agrega source de buscar_en_repositorio_V1.6
#							  porque contiene obtener_fecha
#							  Se usa  la REGLA 2 V3.0 y se rediseña el case
#							  acordemente.	
#			02/10/17 11:05:07 Se modifica agregar_a_no_copiar para obtencion de fecha
#							  y consideracion de archivos tipo GENERAL
#           03/10/17 10:39:40 Se importa verif_dirs_y_files_V1.7.sh
#			03/10/17 13:41:44 Se importa generar_reporte_V1.7.sh
#		1.7 21/10/17 09:55:48 Se cambia en la importacion de modulos a que sea desde
#							  INSTALL_DIR que se extrae de $0
#							 Se incluye listar_modulos_V1.7.sh
#		1.8	27/10/17 22:30:40 Se vuelve a la regla 2 V2.0 para volver a considerar
#							los archivos que estan en el/los repositorio/s	
#							Se importa Verif_dirs_y_files_V1.8.sh
#			29/10/17 19:50:09 Se agregan los contadores let ESTABA_EN_NO_COPIAR++
#							y let ESTABA_EN_ESTR_TEMP++ donde corresponde
#							Se importa generar reporte V1.8
#							Se cambiaron las reglas 3 y 15 a informar_revisar
#			04/11/17 10:42:10 Se corrige doble cuenta de let ESTABA_EN_ESTR_TEMP++
#						dejandolo solo al comienzo y quitandolo del case REGLA
#		1.9 05/12/17 20:10:23 Depurados y adaptados los case para acumular en array de estado
#			05/12/17 21:39:05 Se importa inicializar_contadores_V1.9.sh 
#								generar_reporte_V2.0.sh
#								buscar_en_repositorio_V1.7.sh
#		1.91 06/12/17 12:44:12 Se importa inicializar_contadores_V1.91.sh 
#							Se instrumenta la toma de tiempos parciales de ejecucion
#			 06/12/17 16:56:06 Se agrega la impresion condicional del reporte de tiempos parciales
#								importando reporte_t_parc_V1.0.sh
#		1.95 12/01/18 11:37:31 Esta version incluye 
#								NC_en_mem_V1.95 que contiene las funciones
#									lee_NC_a_mem
#									buscar_en_NC_en_mem
#									reporta_hallado_en_NC
#								buscar_en_repositorio_V1.95
#			13/01/18 08:44:45 Eliminadas las lineas de contadores (comentadas) en el
#					case de la regla
#					En agregar_a_no_copiar se agrega la determinacion si el arch del cel
#					es GT0 antes de averiguar la fecha, ya que si es EQ0 fecha="????"
#					
#		15/01/18 19:50:14 Se incluye verif_dirs_y_files_V1.95.sh
#							Se eliminan lineas de creacion de array de la estr_temp ya que este 
#					se crea en verif_dirs_y_files
#		1.96 05/04/18 16:49:03 	Para unificar los Lista_Files_NO_Copiar en uno solo
#								Se incluye carga_parametros_V1.96
#								verif_dirs_y_files_V1.96
#		2.0	27/04/18 18:05:38 Se incluyen los modulos:
#							inicializar_contadores 		2.0
#							crea_listado_repositorio	2.0
#							buscar_en_repositorio		2.0
# 		12/05/18 22:26:14	Se importa crea_listado_repositorio 2.1
#		15/05/18 21:32:00	Se pasa extension a minuscula en FNAME
#		24/05/18 21:49:02	Se incluye carga_patrones_V2.0.sh
#	V2.2 11/06/18 00:17:54	Nuevo main si carga de funciones
#							
#-----------------------------------------------------------------------


#------------------------------------------------------------------------------
# agregar_a_no_copiar()
# 08/08/18 14:16:36		Estas lineas se comentan por las dudas si hay que volver
#						atras. Estan ahora en el archivo func_vs_main
#------------------------------------------------------------------------------
#{
# Unificar formato con informar_revisar
#
# echo $FNAME "# $AGR_A_NO_COPIAR  $REGLA  $NOM_ABREV $RUN_DATE" | tee -a >>$LISTA_FILES_NO_COPIAR

#if [ "${Fecha_file_cel}" = "0" ]  #3
#then
#    if [ ${TIPO_NOM_ARCH} = "GENERAL" ] #2
#    then
#		Fecha_file_cel="En_Nombre"
#    else   	#2
#        if [ ${TAM} = "GT0" ] #1
#        then
#			Fecha_file_cel="$( obtener_fecha ${FNAME_FULL} )" #--------->>>#
#	    else #1
#			Fecha_file_cel="????"
#		fi  #1
#	fi	#2
#fi #3

#printf "%s  %s  %s  %s\n" ${FNAME} ${Tam_file_cel} ${Fecha_file_cel} "# ${REGLA}  ${NOM_ABREV} ${RUN_DATE}" >>${LISTA_FILES_NO_COPIAR}

#return
#}

#------------------------------------------------------------------------------
Tinicio=$(date +%s)
# let TIEMPO[INICIO_Verif_dirs_y_files]=$(date +%s)
let TIEMPO[INICIO_Verif_dirs_y_files]=${Tinicio}

#-------------------------------------------------------------------------------
# Inclusion de parametros modificables al momento de cada ejecucion
#-------------------------------------------------------------------------------
INSTALL_DIR=${0%/*}

if [ ! -d  ${INSTALL_DIR} ]
then
   echo ${INSTALL_DIR} " No es un directorio"
   echo "Invocar comando con ./${0}"
   exit
fi

# La version del archivo "carga_parametros" es el mismo que el main
# y la obtenemos a partir del mismo

# VER_PARM=${0##*_V}
# VER_PARM=${VER_PARM%.sh*}

# PARMS_A_INCLUIR=carga_parametros_V${VER_PARM}.sh	
	
# En vez de obtener la version del run string, "bob" la sustituye en el siguiente
# renglon al integrar el "ejecutable"
#								  
#		   v-------v justo aca!
VERS_MODS="XYZVVVZXY"

PARMS_A_INCLUIR=carga_parametros_V${VERS_MODS}.sh

if [ ! -f  "${INSTALL_DIR}/${PARMS_A_INCLUIR}" ]
then
	echo "El MODULO ${INSTALL_DIR}/${PARMS_A_INCLUIR} NO existe"
	exit
fi

#  echo "${PARMS_A_INCLUIR}"
#  echo "${INSTALL_DIR}/${PARMS_A_INCLUIR}"
#  exit


source "${INSTALL_DIR}/${PARMS_A_INCLUIR}"
#-------------------------------------------------------------------------------


carga_parametros							#--------->>># 

carga_patrones								#--------->>># 

Verif_dirs_y_files							#--------->>># 

lee_NC_a_mem								#--------->>>#  


let TIEMPO[FIN_Verif_dirs_y_files]=$(date +%s)
let ACUM_TIEMPOS[Verif_dirs_y_files]=${TIEMPO[FIN_Verif_dirs_y_files]}-${TIEMPO[INICIO_Verif_dirs_y_files]}


# Agregar nombres al archivo LISTA_FILES_NO_COPIAR

# Usando la Regla 2, 
# Comparar el listado de archivos "del|en el" celular contra la estructura temporal depurada y
# generar un listado con los nombres de los archivos "no interesantes" que "no hay que copiar"
# Archivo identificado con el nombre del celular
# Con marcas de fecha y hora para identificar los nombres agregados
#
#
#--------------------------------------------------------------------------------------------------------
# Crear array de Estructura temporaria.
# ET_Lista_files  			<--- Lista obtenida con find
# Lista_files_estr_temp		<--- Array indexado de la estr temp ; la clave es el nombre del arch
#
#let TIEMPO[INICIO_ET]=$(date +%s)
#
#ET_Lista_files=$(find ${ESTR_TEMP} -type f | grep -v ${PATRON_DIR_MINIAT_CGATE} | sort )
#
#for ET_full_path_name in ${ET_Lista_files[@]}
#do
#   ET_nom_file=${ET_full_path_name##*/} # EL indice_hash es el NOMBRE DEL ARCHIVO; 
#										# Eliminar Longest match de todo lo que preceda a /
#										# Equivalente a basename, pero mas rapido: Esto lo hace bash...				
#   Lista_files_estr_temp[${ET_nom_file}]=${ET_full_path_name}
#done
#
#let TIEMPO[FIN_ET]=$(date +%s)
#let ACUM_TIEMPOS[ET]=${TIEMPO[FIN_ET]}-${TIEMPO[INICIO_ET]}

#-------------------------------------------------------------------------------
# Aca obtenemos la lista de los archivos copiados del cel o camara


let TIEMPO[INICIO_FILES_DEL_CEL]=$(date +%s)

LISTA_FILES=$(find  $DIR_FILES_COPIADOS_DEL_CEL/ -type f | grep -v "$PATRON_DIR_MINIAT_CGATE" | sort)

let TIEMPO[FIN_FILES_DEL_CEL]=$(date +%s)
let ACUM_TIEMPOS[FILES_DEL_CEL]=${TIEMPO[FIN_FILES_DEL_CEL]}-${TIEMPO[INICIO_FILES_DEL_CEL]}

#-------------------------------------------------------------------------------


let TIEMPO[INICIO_FULL]=$(date +%s)

for FNAME_FULL in ${LISTA_FILES}
do
	Fecha_file_cel="0"
	
	let TOT_FILES_DEL_CEL++
	
	FNAME=${FNAME_FULL##*/} 
	
	obtener_extension 						#--------->>>
	
	FNAME=${FNAME%.*}"."${file_ext} # Le agregamos la extension en minuscula
			        
	if [ ${TIPO_ARCH} = "OTROS" ]
	then
	 let TOT_ESPUREOS_CEL++
	 continue                         # No perdemos tiempo con los archivos "espureos" continuamos con el proximo.
	fi          

	obtener_tipo_archivo					#--------->>>   

	#-------------------------------------------------------------------------------
	let TIEMPO[INICIO_TAM]=$(date +%s)
	
	Tam_file_cel="$(stat -c '%s' ${FNAME_FULL} )"

	# Tamaño mayor de 0?		
	if [ ${Tam_file_cel} != 0 ]  
	  then
		TAM=GT0
		let TAM_GT0++
	  else
		TAM=EQ0
		let TAM_EQ0++
	fi
	let TIEMPO[FIN_TAM]=$(date +%s)
	let ACUM_TIEMPOS[TAM]=${ACUM_TIEMPOS[TAM]:-0}+${TIEMPO[FIN_TAM]}-${TIEMPO[INICIO_TAM]}
	
	#---------------------------------------------------------------------------
	# Esta en el repositorio?
	
	let TIEMPO[INICIO_BUSCAR_EN_REP]=$(date +%s)
	
	buscar_en_repositorio						#--------->>>#
	
	let TIEMPO[FIN_BUSCAR_EN_REP]=$(date +%s)
	let ACUM_TIEMPOS[BUSCAR_EN_REP]=${ACUM_TIEMPOS[BUSCAR_EN_REP]:-0}+${TIEMPO[FIN_BUSCAR_EN_REP]}-${TIEMPO[INICIO_BUSCAR_EN_REP]}
	
	#---------------------------------------------------------------------------
	# Esta en Lista No Copiar? Ahora en memoria
	
	let TIEMPO[INICIO_NO_COPIAR]=$(date +%s)
	
	buscar_en_NC_en_mem							#--------->>>#
	
	let TIEMPO[FIN_NO_COPIAR]=$(date +%s)
	let ACUM_TIEMPOS[NO_COPIAR]=${ACUM_TIEMPOS[NO_COPIAR]:-0}+${TIEMPO[FIN_NO_COPIAR]}-${TIEMPO[INICIO_NO_COPIAR]}
	#---------------------------------------------------------------------------
#	Esta en Estr_Temp?       
	  
	if [ ${#Lista_files_estr_temp[${FNAME}]} = "0" ]
	then
	  EN_ESTR_TEMP=NO
	else
	  EN_ESTR_TEMP=SI
	fi

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
	
    REGLA="${TAM}_${EN_REPOS[1]}_${EN_REPOS[0]}_${EN_NO_COPIAR}_${EN_ESTR_TEMP}"
    let CONT_ESTADO[${REGLA}]++
    
	echo "$NOM_ABREV: $TOT_FILES_DEL_CEL $FNAME $REGLA  Procesado" >>$ARCHIVO_LOG

	case $REGLA in
	GT0_SI_NO_NO_NO)	#1
		let NO_ACCION++
		;;
	GT0_SI_NO_NO_SI ) #2 
		let INF_REV++
		informar_revisar
        ;;        
    GT0_SI_NO_SI_NO  ) #3
		let INF_REV++
        informar_revisar
        ;;  
        
	GT0_SI_NO_SI_SI ) #4
		let INF_REV++
		informar_revisar
		;;
	GT0_SI_SI_NO_NO )   #5 
		let INF_REV++
        informar_revisar
        ;;
	 GT0_SI_SI_NO_SI )  #6 
		let INF_REV++
		informar_revisar
        ;;
	  GT0_SI_SI_SI_NO ) #7 
		let INF_REV++		
        informar_revisar
        ;;  
	GT0_SI_SI_SI_SI )   #8
		let INF_REV++
		informar_revisar
        ;;
	GT0_NO_NO_NO_NO ) 	#9
		let AGR_A_NO_COPIAR++
		agregar_a_no_copiar
	    ;;   
	GT0_NO_NO_NO_SI  ) 	#10
		let NO_ACCION++
		;;
	GT0_NO_NO_SI_NO )  #11
		let NO_ACCION++
		;;	
    GT0_NO_NO_SI_SI )   # 12
		let INF_REV++
        informar_revisar
        ;; 	
    GT0_NO_SI_NO_NO )   # 13
		let NO_ACCION++
		;;
	GT0_NO_SI_NO_SI  )  # 14 
		let INF_REV++
        informar_revisar
        ;;   
	GT0_NO_SI_SI_NO )  # 15 
	  	let INF_REV++
        informar_revisar
        ;;        
	GT0_NO_SI_SI_SI )  # 16
		let INF_REV++
        informar_revisar
        ;;   
   
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
#TAM EQ0
#
	EQ0_SI_NO_NO_NO)        #1
		let INF_REV_Y_NO_COPIAR++
		agregar_a_no_copiar
		informar_revisar
		;;
	EQ0_SI_NO_NO_SI )       #2
		let INF_REV++
        informar_revisar
        ;;
	EQ0_SI_NO_SI_NO )        #3
		let INF_REV++
		informar_revisar
		;;
	EQ0_SI_NO_SI_SI ) 	#4
		let INF_REV++
        informar_revisar
        ;;    
       
	EQ0_SI_SI_NO_NO  )    #5 
		let INF_REV++
        informar_revisar
        ;;
    EQ0_SI_SI_NO_SI  )    #6 
		let INF_REV++
        informar_revisar
        ;;
	EQ0_SI_SI_SI_NO )    #7 
		let INF_REV++
        informar_revisar
        ;;
	EQ0_SI_SI_SI_SI )     #8   
		let INF_REV++
        informar_revisar
        ;;
        
	EQ0_NO_NO_NO_NO )	#9
		let AGR_A_NO_COPIAR++
		agregar_a_no_copiar
	    ;;
	EQ0_NO_NO_NO_SI )       #10
		let INF_REV++
		informar_revisar
        ;;
	EQ0_NO_NO_SI_NO )	#11 
		let NO_ACCION++
		;;
	EQ0_NO_NO_SI_SI )  	#12
		let INF_REV++
        informar_revisar
        ;;
	EQ0_NO_SI_NO_NO )	#13		
		let INF_REV_Y_NO_COPIAR++
		agregar_a_no_copiar
		informar_revisar
		;;
	EQ0_NO_SI_NO_SI )	#14
		let INF_REV++
        informar_revisar
        ;;
	EQ0_NO_SI_SI_NO )	#15
		let INF_REV++
        informar_revisar
		;;
	EQ0_NO_SI_SI_SI )	#16
		let INF_REV++
        informar_revisar
        ;;
	*) 
	    echo "$FNAME: $REGLA Esta combinacion esta mal"
	    ;;
	esac


done	
#---------------------------------------------------------------------------------

Tfin_estr_temp=$(date +%s)

let TIEMPO[FIN_FULL]=$(date +%s)
let ACUM_TIEMPOS[FULL]=${TIEMPO[FIN_FULL]}-${TIEMPO[INICIO_FULL]}

# Generar REPORTE

# Con colores a la pantalla
COLORES=TRUE
generar_reporte 										#--------->>>#

# Sin colores al LOG
COLORES=FALSE
generar_reporte >> ${ARCHIVO_LOG}						#--------->>>#



# Generar reporte tiempos parciales
if [ ${GENERAR_REP_T_PARC} = "TRUE" ]
then
	reporte_t_parc | tee -a ${ARCHIVO_LOG}				#--------->>>#
fi

exit




