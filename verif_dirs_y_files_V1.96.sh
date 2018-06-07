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


