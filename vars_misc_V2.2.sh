#!/bin/bash

vars_misc ()
{
#	V2.2 12/06/18 22:11:38 Agrupacion de variables misc que vienen de carga_parametros
	
# RUN_DATE Fecha y hora de la ejecucion del script
RUN_DATE="$(date  +\#\ %Y\/%m\/%d\ %H:%M)"
RUN_DATE_FILE="$(date  +%Y-%m-%d_%H%M)"    # Nuevo formato para usar en nombres de Archivo

#--------------------------------------------------------------------------------------------------------

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
#
# String para convertir fecha de exiftool   
#             AAAA:MM:DD HH:MM:SS
# a formato   AAAA-MM-DD_HH:MM:SS

Str_conv_fecha='s/.*([0-9]{4}):([0-9]{2}):([0-9]{2}) (.*)/\1-\2-\3_\4/'

}
