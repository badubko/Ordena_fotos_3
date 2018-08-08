#!/bin/bash
#  Version:    	0.2 25/07/17 20:57:28 
#              	0.4 28/07/17 00:25:37 
#	 	0.5 29/07/17 10:56:22 
#               0.6 01/08/17 10:53:06 Referencia version 0.6 de 
#                                     carga parameteros y verif_dirs_y_files    OK
#				      carga inicializar contadores V0.6         OK
#				A implemetar:
#                               Uniformar agregar_a_no_copiar 			OK... FALTA mas
#				usar Informar_revisar comun			OK
#                               Escribir al LOG 				OK
#                               Cambiar el read por find a una variable		OK
#				Agregar contadores 				OK
#                               Generar reporte	Agregado DIR Origen		OK
#                               cambiada linea de copia a:
#                   		cp -p $FNAME_FULL "$ESTR_TEMP/$Dir_dest/$FNAME"
#		0.7 02/08/17 11:17:43 Nueva referencia de carga parametros y verif_dirs..
#                     		Se agrego la funcion de creacion de listado repositorio.
#                               Agregado el caso canon. FALTA mejorar y completar
#               0.8 07/08/17 07/08/17 13:57:41 Referencia versiones 0.8 de
#				carga_parametros
#				crea_listado_repositorio
#				verif_dirs_y_files_V0.8
#				inicializar_contadores
# 				que generan las listas de contenidos de Dir0 y Dir1
#		---->		Este script verifica que los arch del celular no esten ya en los #				repositorios Dir0 y Dir1
#				Invoca a la funcion generar_reporte que es importada del archivo
#				generar_reporte_V0.8.sh
#		     11/08/17 18:25:36 Incluye verif_dir_y_files V0.81 solo para uniformidad.
#               0.81 13/08/17 17:04:56 Incluye vers 0.81 de crea_listado_repositorio
#				       Lista las versiones de los modulos.
#				       Se agrega str_32 a los casos de nombres
#		1.1 24/08/17 23:43:45 Se cambia el orden de los source, adelantando inicializar contadores
#		    25/08/17 09:40:10 Se incluyen versiones 1.1 de crea... y verif...
#		    25/08/17 21:38:47 inicializar contadores 1.1 deja de ser una funcion
#		1.2 26/08/17 10:31:38 Se modifica la seccion de busqueda en repositorios ya que ahora
#				estan en memoria (en vez de ser un archivo)
#				Se agrega la funcion buscar_en_sinonimos
#				Se agregan variables Tinicio_estr_temp  Tfin_estr_temp
#		    28/08/17 20:36:05 Se agrego variable Tinicio
#               1.3 03/09/17 	Se agrego source de buscar_en_repositorio_V1.3.sh
#		1.4 04/09/17 10:55:09 Invoca a version 1.4 de buscar en repositorio
#	        1.5 08/09/17 00:05:51 Invoca a version 1.5 de buscar en repositorio
#                                     Invoca a version 1.5 de Carga Parametros
# 				      Los videos no se copian. En vez, se crea un script de copia.
#		    08/09/17 12:41:27 Se agrega funcion obtener_extension
#		    11/09/17 12:09:38 Se crea la funcion caso_canon_u_otra_cosa que reemplaza al caso_canon y al caso_otra_cosa
#				      Cubre los casos de los archivos que no tienen fecha en el nombre.
#			15/09/17 13:57:18 	Se modifica Agregar a no copiar agregando Tamaño y Fecha del archivo del cel 
#								Se usa printf en vez de echo
#							    Se agrega la inclusion y llamada a la funcion externa buscar_en_no_copiar
#			17/09/17 02:03:57   Se volvio al formato original de exiftool sin el grep.
#			17/09/17 21:23:01	Se agrego funcion obtener_tipo_archivo y se modifico la funcion obtener_dir_dest
#								Se modifico caso_canon_u_otra_cosa: ahora pregunta si Fecha_file_cel != 0 para 
#								saber si ya se habia determinado la fecha.
#			18/09/17 15:18:17	Se separan los casos EQ0SISINO y EQOSISISI
#							    Se agrego determinacion de FNAME a partir de FNAME_FULL al comienzo
#								Se agrego funcion listar_modulos que escribe al log y formatea con printf
#		1.6	21/09/17 14:17:59	Se cambio buscar_en_no_copiar a version 1.6
#			21/09/17 16:56:03	Se agrega source de listar_modulos_V1.5 y se eliminan lineas de este file
#								correspondientes a esta funcion
#								Se agrega source de obtener_extension_y_tipo y se eliminan las lineas
#								Se agrego let ESTABA_EN_NO_COPIAR++ en los casos que el file estaba en NC
#			22/09/17 13:08:04	Se separo carga_patrones en file aparte y se lo incluye con source
#								En caso_general se cambio echo por <<<${FNAME} y se elimino obtener_extension
#								dado que se obtiene siempre al comienzo 
#			29/09/17 00:42:03	Se hace source de buscar_en_repositorio_V1.6.sh
#								Se cambian todas las invocaciones de exiftool con sed por
#								llamadas a obtener_fecha
#			29/09/17 19:39:19   Se modifico caso_canon_u_otra_cosa, unificando y eliminando
#								el case de FOTO o VIDEO. Se simplifico todo la funcion.
#           03/10/17 10:39:40 Se importa verif_dirs_y_files_V1.7.sh
#			03/10/17 13:41:44 Se importa generar_reporte_V1.7.sh
#		1.7	21/10/17 09:16:22 Se cambia en la importacion de modulos a que sea desde
#							  INSTALL_DIR que se extrae de $0
#                             Se incluye listar_modulos_V1.7.sh
#			25/10/17 22:07:14 Se agrego let AGR_A_NO_COPIAR++ a EQ0SINONO | EQ0NOSINO )
#			27/10/17 22:59:42 Se importa verif_dirs_y_files_V1.8 por compatibilidad 
#			29/10/17 19:57:25 Se importa generar reporte V1.8 por compatibilidad    
#		1.8	09/11/17 00:35:19 Se modifica formato del string REGLA intercalando "_" para mayor
#							legibilidad "GT0SINOSI" queda  "GT0_SI_NO_SI" 
#							Se adecuan las lineas del case  
#		1.9 22/11/17 14:59:57 Se reordenan los contadores de estado y accion pasandolos al cuerpo del 
#							case. Se separan los case.    
#			27/11/17 10:24:06 Se invocan versiones nuevas de:
#							inicializar_contadores    V1.8   
#							generar_reporte     V1.9  
#							buscar_en_repositorio    V1.7
#							En los case se utiliza la matriz de contadores de estado
#							Se invoca 2 veces el reporte, sin y con colores
#			05/12/17 21:39:05 Se importa inicializar_contadores_V1.9.sh 
#								generar_reporte_V2.0.sh
#								por consistencia
#   		24/12/17 01:26:36 Se importa   inicializar_contadores_V1.91.sh           
#								por consistencia
#		1.95 12/01/18 11:37:31 Esta version incluye 
#								NC_en_mem_V1.95 que contiene las funciones
#									lee_NC_a_mem
#									buscar_en_NC_en_mem
#									reporta_hallado_en_NC
#								buscar_en_repositorio_V1.95
#			15/01/18 19:50:14 Se incluye verif_dirs_y_files_V1.95.sh
#		1.96 05/04/18 16:49:03 	Para unificar los Lista_Files_NO_Copiar en uno solo
#								Se incluye carga_parametros_V1.96
#								verif_dirs_y_files_V1.96
# 		2.0 16/04/18 14:03:28  Incluye v2.0 de inicializar_contadores y 
#								v2.0 de crea_listado_repositorio
#								Version de prueba hasta aqui... solo para probar nuevas
#								funciones de generacion de sinonimos en repositorio
#			27/04/18 12:48:24   Incluye buscar_en_repositorio_V2.0
#			08/05/18 17:05:21    se corrigio ${Tam_file_cel:-0}
# 			12/05/18 22:26:14	Se importa crea_listado_repositorio 2.1
#			15/05/18 20:32:38	Se pasa la extension del arch a minuscula en FNAME
#			24/05/18 21:49:02	Se incluye carga_patrones_V2.0.sh y obtener_extension_y_tipo_V2.1
#			25/05/18 14:27:38	Modificado caso_general 
#			26/05/18 23:51:49	En regla EQ0_SI_SI_NO  se comento la linea 
#								#            let AGR_A_NO_COPIAR++
#	V2.2	11/06/18 00:15:49	Nuevo main sin carga de funciones
#								cat ${LISTA_FUNCIONES[a_nc]} "a_nc_main_V2.2.sh"  >a_nc_V2.2.sh
#   V2.3	06/08/18 16:31:16	Futura version donde se averigua la version de carga_parametros
#								sacandola del mail
#--------------------------------------------------------------------------------
caso_canon_u_otra_cosa ()
#-------------------------------------------------------------------------------
{
# Caso Canon, Canon like  y otros achivos que no tengan fecha en el nombre...
# Separamos en tipo FOTO y VIDEO solo para preveer que se tenga q usar algun otro metodo para obtener la fecha.

# echo "${FNAME}  es Canon like u otra cosa "

	
	     #  Si ya habiamos obtenido la fecha al comparar files
	     #  ya tenemos  2017-04-25_HH:MM:SS porque se tuvo que recurrir a comparar fechas; 
		 #  recortamos solo la fecha

		if [ ${Fecha_file_cel} =  "0"  ]          
		then
			# Si no tenemos fecha, obtenerla.
			Fecha_file_cel="$( obtener_fecha ${FNAME_FULL} )"				
		fi
		if [ ${Fecha_file_cel} =  "????" ]	
		then
		    Dir_dest="Sin_Fecha"
		else     
            Dir_dest="${Fecha_file_cel%_*}"
        fi
       
return
}

#-------------------------------------------------------------------------------
caso_general ()
#-------------------------------------------------------------------------------
{
# echo "Es de los generales sacar fecha del nombre"

grep -q -e "$str_12\|$str_14\|$str_15" <<<${FNAME}
 if [ $? = "0" ]
 then
	Dir_dest=$( /bin/sed 's/^\([0-9]\{4\}\)\([0-9]\{2\}\)/\1-\2-/' <<<${FNAME} )
	Dir_dest=${Dir_dest:0:10} 
 else
	# Eliminar prefijo tipo IMG, DSCN, etc ; convertir a AAAA-MM-DD y quedarnos con esos primeros 10 caract
	#  Dir_dest=$( /bin/sed "$str_sustit" <<<${FNAME} |  /bin/sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)/\1-\2-/' | /usr/bin/cut -c1-10)
    #  Dir_dest=$( /bin/sed "$str_sustit" <<<${FNAME} |  /bin/sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)/\1-\2-/' )
    Dir_dest=$( /bin/sed -e "$str_sustit" -e 's/\([0-9]\{4\}\)\([0-9]\{2\}\)/\1-\2-/' <<<${FNAME}  )
    Dir_dest=${Dir_dest:0:10} 
 fi


return
}

#-------------------------------------------------------------------------------
obtener_dir_dest ()
#-------------------------------------------------------------------------------
{
  case ${TIPO_NOM_ARCH} in
  CANON )
	let Tipo_Canon++  	   
	caso_canon_u_otra_cosa	#--------->>>#
  ;;
  OTRA_COSA )
	let Tipo_Otra_Cosa++
	caso_canon_u_otra_cosa	#--------->>>#
  ;;
  GENERAL )
	let Tipo_General++	
	caso_general			#--------->>>#
  ;;
  esac

return
}

#-------------------------------------------------------------------------------
agregar_a_estr_temp ()
#-------------------------------------------------------------------------------
{
obtener_dir_dest
	if [ ! -d "$ESTR_TEMP/$Dir_dest" ]
	then
	  mkdir "$ESTR_TEMP/$Dir_dest"
	fi

#		     echo "$ESTR_TEMP/$Dir_dest/$FNAME"
#		     echo
		     
	 case ${TIPO_ARCH} in
	 FOTO )
	   cp -p $FNAME_FULL "$ESTR_TEMP/$Dir_dest/$FNAME"
	 ;;
	 VIDEO )
	   echo "cp -p ${FNAME_FULL} ${ESTR_TEMP}/${Dir_dest}/${FNAME}"  >>${WORK_SCRIPT_VID}
	 ;;
	 * )
	   echo  "${NOM_ABREV}: Paranoia check ${FNAME} tipo no previsto ${TIPO_ARCH}" 
	 ;;
	 esac               

# Limpiar variables para la proxima vuelta, para cuando se determine el tipo de arch
# tempranamente en buscar_en_repositorio
return
}
#-------------------------------------------------------------------------------
informar_revisar ()
{

#  Hasta tanto no se implemente el contador
   echo "$NOM_ABREV: $INF_REV $FNAME $REGLA  Informar/Revisar" 	>>$ARCHIVO_LOG
   printf "\n" 													>>$ARCHIVO_LOG

return
}
#-------------------------------------------------------------------------------
agregar_a_no_copiar()
{
# Unificar formato con informar_revisar
#
# En todos los casos de Fotos_cel_a_Estr_Temp el Tamaño sera "0" y la fecha "????"
# debido a que SOLAMENTE se agregan a N/C los archivos de tamaño=0
#
printf "%s  %s  %s  %s\n" ${FNAME} ${Tam_file_cel} "????" "# ${AGR_A_NO_COPIAR}  ${REGLA}  ${NOM_ABREV} ${RUN_DATE}" >>$LISTA_FILES_NO_COPIAR

return
}

#-------------------------------------------------------------------------------
# Cuerpo programa principal
#-------------------------------------------------------------------------------

Tinicio=$(date +%s)

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

# En vez de obtener la version del run string, "bob" la sustituye en el siguiente
# renglon al integrar el "ejecutable"
#								  
#		   v-------v justo aca!
VERS_MODS="XYZVVVZXY"

configura_parametros

PARMS_A_INCLUIR=carga_parametros_V${VERS_MODS}.sh		


if [ ! -f  "${INSTALL_DIR}/${PARMS_A_INCLUIR}" ]
then
	echo "El MODULO ${INSTALL_DIR}/${PARMS_A_INCLUIR} NO existe"
	exit
fi

#  echo "${PARMS_A_INCLUIR}"
#  echo "${INSTALL_DIR}/${PARMS_A_INCLUIR}"


source "${INSTALL_DIR}/${PARMS_A_INCLUIR}"

carga_parametros							#--------->>>#

# echo ${REPOSITORIO[@]}
# exit 
#-------------------------------------------------------------------------------

carga_patrones								#--------->>>#

# inicializar_contadores   <---- NO es mas una funcion

Verif_dirs_y_files 							#--------->>>#  

lee_NC_a_mem								#--------->>>#  


#-------------------------------------------------------------------------------

Tinicio_estr_temp=$(date +%s)

LISTA_FILES=$(find  $DIR_FILES_COPIADOS_DEL_CEL/ -type f | grep -v "$PATRON_DIR_MINIAT_CGATE" | sort)


for FNAME_FULL in ${LISTA_FILES}
do
	  let TOT_FILES_DEL_CEL++
	  TIPO_NOM_ARCH=""              # Ponemos esta variable en null; 
									# Podria decir "CANON" para evitar un viaje con exiftool
									# En Vers 1.6 esto ya no importa: siempre se determina 
									# TIPO_NOM_ARCH
      Fecha_file_cel="0"
      
      FNAME=${FNAME_FULL##*/} 	
            
		obtener_extension			#--------->>>
		 						
		FNAME=${FNAME%.*}"."${file_ext} # Le agregamos la extension en minuscula
		
		if [ ${TIPO_ARCH} = "OTROS" ]
		then
			let TOT_ESPUREOS_CEL++
			continue                         # No perdemos tiempo con los archivos "espureos" continuamos con el proximo.
		fi          

	  obtener_tipo_archivo                    	#--------->>>
	  
      Tam_file_cel="$(stat -c '%s' ${FNAME_FULL} )"

	# Tamaño distinto de 0?		
		if [ ${Tam_file_cel:-0} != 0 ]  
		then
			TAM=GT0
			let TAM_GT0++
		else
		    TAM=EQ0
			let TAM_EQ0++
		fi
 
	# Esta en el repositorio?

	buscar_en_repositorio						#--------->>>#
	
	# Esta en Lista No Copiar?  Ahora en memoria
    
	buscar_en_NC_en_mem							#--------->>>#
    
#-------------------------------------------------------------------------------
	# Clasificar segun regla 1  
#-------------------------------------------------------------------------------
	REGLA="${TAM}_${EN_REPOS[1]}_${EN_REPOS[0]}_${EN_NO_COPIAR}"
	
    let CONT_ESTADO[${REGLA}]++
 
# echo "Regla:  "${REGLA}

	case $REGLA in
	  GT0_SI_NO_NO  )
	    let ESTABA_EN_REPOSIT[1]++  		#<----------- Remover Luego?
	    let NO_ACCION++
#	    echo "$NOM_ABREV: $FNAME  $REGLA NADA"
	    ;;
	  GT0_NO_SI_NO )
	    let ESTABA_EN_REPOSIT[0]++ 			#<----------- Remover Luego?
	    let NO_ACCION++
		;;
	  GT0_NO_NO_SI )
	    let ESTABA_EN_NO_COPIAR++  			#<----------- Remover Luego?
	    let NO_ACCION++
	    ;;  
	  GT0_SI_SI_SI )
#        let EN_AMBOS_REP++
#        let ESTABA_EN_NO_COPIAR++
#        let EN_AMBOS_REP_Y_NO_COPIAR++
	    let INF_REV++
	    informar_revisar					#--------->>>#
	    ;;
	  GT0_SI_SI_NO )
#	   let EN_AMBOS_REP++
       let INF_REV++
	   informar_revisar						#--------->>>#
	    ;;   
	  GT0_SI_NO_SI | GT0_NO_SI_SI )
        let INF_REV++
#        let ESTABA_EN_NO_COPIAR++
	    informar_revisar					#--------->>>#
	    ;;

	  GT0_NO_NO_NO)
        let AGR_A_ESTR_TEMP++
#	    echo "$FNAME Copiar a ESTR_TEMP"
	    agregar_a_estr_temp			#--------->>># Aca agregamos a estr temporaria
	    ;;

      EQ0_SI_NO_NO | EQ0_NO_SI_NO )
          # Caso especial= Agregar a NO_COPIAR e INFORMAR; hay que revisar a mano 
          # Se trata probablemente de un archivo que se corrompio en el celular (tam EQ0) pero se habia     		  
		  # copiado anteriormente cuando estaba con tam GT0
          # Se debe agregar a NO_COPIAR para que sea descartado en el futuro.
#            let EQ0_Y_EN_REP++
#            let AGR_A_NO_COPIAR++
            let INF_REV_Y_NO_COPIAR++
            agregar_a_no_copiar					#--------->>>#
			informar_revisar					#--------->>>#
	    ;;
      EQ0_SI_SI_NO  )
#            let AGR_A_NO_COPIAR++
#            let EN_AMBOS_REP++                 #<----------- Remover Luego?
            let INF_REV_Y_NO_COPIAR++
            agregar_a_no_copiar					#--------->>>#
			informar_revisar					#--------->>>#
	    ;;
	  EQ0_SI_SI_SI  )
#			let EN_AMBOS_REP++					#<----------- Remover Luego?
            let INF_REV++
#            let ESTABA_EN_NO_COPIAR++			#<----------- Remover Luego?
			informar_revisar					#--------->>>#
	  ;;  
      EQ0_SI_NO_SI | EQ0_NO_SI_SI )
			let INF_REV++						#<----------- Remover Luego?
# 			let ESTABA_EN_NO_COPIAR++
			informar_revisar					#--------->>>#
	    ;;
	  EQ0_NO_NO_SI)
#			let ESTABA_EN_NO_COPIAR++			#<----------- Remover Luego?
			let NO_ACCION++
#	    	echo "$NOM_ABREV: $FNAME  $REGLA NADA"
	    ;;
	  EQ0_NO_NO_NO)
		   let AGR_A_NO_COPIAR++
#		   echo "$FNAME  $REGLA Agregar a NO Copiar"
		   agregar_a_no_copiar					#--------->>>#
	    ;;
	  *)
			echo "$FNAME: $REGLA Esta combinacion esta mal"
	    ;;
	  esac
done

Tfin_estr_temp=$(date +%s)

# Generar REPORTE

# Con colores a la pantalla
COLORES=TRUE
generar_reporte 										#--------->>>#

# Sin colores al LOG
COLORES=FALSE
generar_reporte >> ${ARCHIVO_LOG}						#--------->>>#

exit




