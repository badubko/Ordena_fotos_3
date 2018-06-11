#! /bin/bash


declare -A LISTA_FUNCIONES

LISTA_FUNCIONES[a_et]="carga_parametros_V1.96.sh \
                       crea_listado_repositorio_V2.1.sh \
                       listar_modulos_V1.7.sh \
						verif_dirs_y_files_V1.96.sh \
						carga_patrones_V2.0.sh \
						obtener_extension_y_tipo_V2.1.sh \
						buscar_en_repositorio_V2.0.sh \
						NC_en_mem_V1.95.sh \
						generar_reporte_V2.0.sh \
						inicializar_contadores_V2.0.sh"
						
LISTA_FUNCIONES[a_nc]="carga_parametros_V1.96.sh \
						crea_listado_repositorio_V2.1.sh \
						listar_modulos_V1.7.sh \
						verif_dirs_y_files_V1.96.sh \
						carga_patrones_V2.0.sh \
						obtener_extension_y_tipo_V2.1.sh \
						buscar_en_repositorio_V2.0.sh \
						NC_en_mem_V1.95.sh \
						generar_reporte_V2.0.sh \
						reporte_t_parc_V1.0.sh \
						inicializar_contadores_V2.0.sh"



RUN_DATE="$(date  +\#\ %Y\/%m\/%d\ %H:%M)"
RUN_DATE_FILE="$(date  +%Y-%m-%d_%H%M)"  

DIR_REF=${HOME}"/Documents/Ordena_Fotos_Cel"

if [ $# = 0 ]
then
   echo "Entrar el nombre del script... Opciones:"
   echo  "a_at |  1"
   echo  "a_nc | 2 "
   exit
fi

case $1 in
a_et | 1 )
	
	
	for A_INCLUIR in ${LISTA_FUNCIONES[a_et]} a_et_main_V2.2.sh
	do
		if [ ! -f  "${A_INCLUIR}" ]
		then
			echo "La funcion ${A_INCLUIR} NO existe"
			exit
		fi
	done
	echo cat ${LISTA_FUNCIONES[a_et]} "a_et_main_V2.2.sh"  >a_et_V2.2.sh
	
	;;
a_nc | 2 ) 
	

	
	for A_INCLUIR in ${LISTA_FUNCIONES[a_nc]} a_nc_main_V2.2.sh
	do
		if [ ! -f  "${A_INCLUIR}" ]
		then
			echo "La funcion ${A_INCLUIR} NO existe"
			exit
		fi
	done
	
	echo cat ${LISTA_FUNCIONES[a_nc]} "a_nc_main_V2.2.sh"  >a_nc_V2.2.sh
	;;
*)
	echo "$1 Opcion no conocida"
	exit
	;;
esac 

