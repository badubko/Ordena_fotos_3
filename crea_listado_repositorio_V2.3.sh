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
#   echo ${Tfind} 
	date "+%F %T"
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
#			echo ${T0} 
			date "+%F %T"
			generar_lista_rep_en_mem        #  ------------->>> Aca esta la madre de Dorrego

			Tfin=$(date +%s)
#			echo ${Tfin}
			date "+%F %T"
							#  ------------->>>  Aca se generan listados para ver que encontramos.
			reporte_de_repositorio
			reporte_de_duplicados

		else #3
			echo "$NOM_ABREV: NO se creara listado del repositorio ${REPOSITORIO[$NUM_REPOS]}"
		fi #3
			 # Aca hay una falla de logica: seria posible no generar listado
			 # de los repositorios y seguir adelante con resultados impredecibles
			 #*************************************************************
			 if [ ${SOLO_REGEN_LISTA_FILES_REP[$NUM_REPOS]^^} = "TRUE" ]  #2.2
			 then
				   echo "${FUNCNAME}: TERMINAR= ${SOLO_REGEN_LISTA_FILES_REP[$NUM_REPOS]^^} "
				   exit  # <----------------- Solo generamos la lista y salimos.	             
			 fi #2.2
			#*************************************************************
	fi #4 
done

return
}

