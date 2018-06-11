#! /bin/bash


declare -A LISTA_FUNCIONES MAIN OUT_FILE

LISTA_FUNCIONES[a_et]="carga_parametros_V2.2.sh \
                       crea_listado_repositorio_V2.2.sh \
                       listar_modulos_V2.2.sh \
						verif_dirs_y_files_V2.2.sh \
						carga_patrones_V2.2.sh \
						obtener_extension_y_tipo_V2.2.sh \
						buscar_en_repositorio_V2.2.sh \
						NC_en_mem_V2.2.sh \
						generar_reporte_V2.2.sh \
						inicializar_contadores_V2.2.sh"
						
LISTA_FUNCIONES[a_nc]="carga_parametros_V2.2.sh \
						crea_listado_repositorio_V2.2.sh \
						listar_modulos_V2.2.sh \
						verif_dirs_y_files_V2.2.sh \
						carga_patrones_V2.2.sh \
						obtener_extension_y_tipo_V2.2.sh \
						buscar_en_repositorio_V2.2.sh \
						NC_en_mem_V2.2.sh \
						generar_reporte_V2.2.sh \
						reporte_t_parc_V2.2.sh \
						inicializar_contadores_V2.2.sh"
MAIN[a_et]=a_et_main_V2.2.sh
MAIN[a_nc]=a_nc_main_V2.2.sh

OUT_FILE[a_et]=${MAIN[a_et]/_main/} # Quitamos el "_main"
OUT_FILE[a_nc]=${MAIN[a_nc]/_main/}


RUN_DATE="$(date  +\#\ %Y\/%m\/%d\ %H:%M)"
RUN_DATE_FILE="$(date  +%Y-%m-%d_%H%M)"  

DIR_REF=${HOME}"/Documents/Ordena_Fotos_Cel"

if [ $# = 0 ]
then
   echo "Entrar el nombre del script... Opciones:"
   echo  "a_at |  1"
   echo  "a_nc |  2 "
   exit
fi

case $1 in
a_et | 1 )
	
	CUAL_MAIN="a_et"

	;;
a_nc | 2 ) 
	
	CUAL_MAIN="a_nc"
	
	;;
*)
	echo "$1 Opcion no conocida"
	exit
	;;
esac 
	
for A_INCLUIR in ${LISTA_FUNCIONES[${CUAL_MAIN}]} ${MAIN[${CUAL_MAIN}]}
do
	if [ ! -f  "${A_INCLUIR}" ]
	then
		echo "El MODULO ${A_INCLUIR} NO existe"
		exit
	fi
done
#
# Aca viene el banner y la lista de funciones a incluir

if [  -d "${OUT_FILE[${CUAL_MAIN}]}" ]
then
  echo "${NOM_ABREV}: No se puede generar: ${OUT_FILE[${CUAL_MAIN}]} Es un directorio"
  exit
fi

  echo "#! /bin/bash"											>${OUT_FILE[${CUAL_MAIN}]}
  echo "#----------------------------------------------------------------"  >>${OUT_FILE[${CUAL_MAIN}]}
  echo "# Nombre    :  ${OUT_FILE[${CUAL_MAIN}]}"				>>${OUT_FILE[${CUAL_MAIN}]}
  echo "# Creado por: $0     Run_date  : ${RUN_DATE}"         	>>${OUT_FILE[${CUAL_MAIN}]}
  printf "\n"											>>${OUT_FILE[${CUAL_MAIN}]}
  echo "# Directorio Origen:  ${PWD}"  					>>${OUT_FILE[${CUAL_MAIN}]}
  echo "# Warning   : DO NOT EDIT THIS FILE !!!"					>>${OUT_FILE[${CUAL_MAIN}]}
  echo "#----------------------------------------------------------------"  >>${OUT_FILE[${CUAL_MAIN}]}
  echo "# Modulos incluidos:"				  	        >>${OUT_FILE[${CUAL_MAIN}]}

  for A_INCLUIR in ${LISTA_FUNCIONES[${CUAL_MAIN}]} ${MAIN[${CUAL_MAIN}]}
  do
	printf "#                     %s\n" ${A_INCLUIR} >>${OUT_FILE[${CUAL_MAIN}]}
  done
  
  echo "#----------------------------------------------------------------"  >>${OUT_FILE[${CUAL_MAIN}]}
  printf "\n\n"													>>${OUT_FILE[${CUAL_MAIN}]}


# Aca contruimos el main
cat ${LISTA_FUNCIONES[${CUAL_MAIN}]} ${MAIN[${CUAL_MAIN}]}  >>${OUT_FILE[${CUAL_MAIN}]}

# Le sacamos permiso de w para que nadie edite este file
# chmod 555 ${OUT_FILE[${CUAL_MAIN}]}
