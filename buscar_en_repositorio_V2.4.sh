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

