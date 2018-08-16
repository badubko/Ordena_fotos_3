#! /bin/bash

#	V1.6	28/09/17 16:10:56 Creada esta funcion
#			29/10/17 10:51:16 Se elimino la comprobacion de $? a cada case
#
#
#

obtener_fecha ()
{

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



source /home/badubko/Documents/Ordena_Fotos_Cel/inicializar_contadores_V1.1.sh # Ya no es funcion

source /home/badubko/Documents/Ordena_Fotos_Cel/carga_parametros_V1.5.sh


source /home/badubko/Documents/Ordena_Fotos_Cel/carga_patrones_V1.6.sh 

source /home/badubko/Documents/Ordena_Fotos_Cel/obtener_extension_y_tipo_V1.5.sh
source /home/badubko/Documents/Ordena_Fotos_Cel/generar_reporte_V1.2.sh


carga_parametros
carga_patrones

DIR_FILES_COPIADOS_DEL_CEL='/media/CGate/public/Photos/Dir1/2016/2016-01-30_Bar_del_cel_Valen_Prov'

#LISTA_FILES=$(find  $DIR_FILES_COPIADOS_DEL_CEL/ -type f | grep -v "$PATRON_DIR_MINIAT_CGATE" | sort)


#for FNAME_FULL in ${LISTA_FILES}

for FNAME_FULL in $(find  ${DIR_FILES_COPIADOS_DEL_CEL}/ -type f | grep -v "$PATRON_DIR_MINIAT_CGATE" | sort)
do

	FNAME=${FNAME_FULL##*/} 
	obtener_extension
	obtener_tipo_archivo

	if [ ${TIPO_ARCH} = "OTROS" ]
    then
             let TOT_ESPUREOS_CEL++
             echo "------------->>>>   Espureo: ${FNAME}"
             continue                         # No perdemos tiempo con los archivos "espureos" continuamos con el proximo.
    fi        
 

    echo "${FNAME}"   "Fecha: " "$(obtener_fecha ${FNAME_FULL})"
    
    
done    

echo "TOT_ESPUREOS:  ${TOT_ESPUREOS_CEL}"
