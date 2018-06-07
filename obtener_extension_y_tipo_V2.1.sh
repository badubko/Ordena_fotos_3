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
