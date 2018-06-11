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
