#! /bin/bash
#------------------------------------------------------------------------
# Generar REPORTE
#------------------------------------------------------------------------

#	Version 0.8 07/08/17 18:59:32 Se crea esta funcion en archivo aparte
#		  extractado de Fotos_cel_a_Estr_Temp_V0.8.sh
#		1.2 27/08/17 21:11:20 Se agregan las lineas de reporte de tiempos; 
#		    	28/08/17 20:35:08 Se agrega variable Tinicio
#		    	07/09/17 23:05:05 Se agregan los contadores Tipo_Canon y  Det_por_fecha
#				26/09/17 22:09:14 Se agregan contadores de Foto y Video
#			    03/10/17 00:57:59 Agregado de {} y :-0 
#       1.7 03/10/17 13:39:48 Se hacen 2 variantes en un unico file eliminando
#							las variables que no se usan en 
#                           Gen_list_files_cel_NO_copiar
#                           Se cambia el here document por lineas con printf
#			25/10/17 19:52:30 Se agrego la impresion de variable $AGREGAR_A_ESTR_TEMP
#							y se cambio el orden de impresion
#		1.8	29/10/17 19:54:25 Se adecuaron los reportes al uso de Regla 2 V2.0 en
#							Gen_list_files_NO_copiar_V1.8
#		1.9	27/11/17 10:27:52 Version con matriz de contadores de Estado y eliminacion
#							de impresion de algunos contadores de Estado
#		2.0	05/12/17 21:41:10 Version que incluye el reporte para Gen_list_files_NO_copiar
#			27/05/18 00:04:51 Se agrego al total de acciones +${INF_REV_Y_NO_COPIAR}
#							

generar_reporte ()
{

#------------------------------------------------------------------------
# Para a_et
#------------------------------------------------------------------------
	
printf "\n\n"	
if [ ${COMANDO_COMPLETO} = "Fotos_cel_a_Estr_Temp" ] || [ ${COMANDO_COMPLETO} = "a_et" ]
then	

printf "Generado por     : %s \n" 	$0 
printf "          Reporte: %s \n" 	"${RUN_DATE}"
printf "Directorio Origen: %s \n\n" ${DIR_FILES_COPIADOS_DEL_CEL}

printf "Tiempo generac Estr Temp: %5s seg\n"    $[${Tfin_estr_temp:-0}-${Tinicio_estr_temp:-0}]	
printf "Tiempo total ejecucion  : %5s seg\n\n"  $[${Tfin_estr_temp:-0}-${Tinicio:-0}]

printf "TOT_FILES_DEL_CEL  : %5s\n"   ${TOT_FILES_DEL_CEL}
printf "TOT_ESPUREOS_CEL   : %5s\n\n" ${TOT_ESPUREOS_CEL}

# Reporte de Estado

let TOT_GT0=0
let TOT_EQ0=0

printf "                          GT0                                   EQ0\n"
printf "%-10s       %4s %4s %4s %5s    %6s           %4s %4s %4s %5s\n" "Estado" "REP1" "REP0" "N/C" "CANT" "Estado"  "REP1" "REP0" "N/C" "CANT"

FMT1="%-26b %4s %4s %4s %6s    %-26b %4s %4s %4s %6s\n"
FMT2="%-15s %4s %4s %4s %6s    %-15s %4s %4s %4s %6s\n"

for EN_REPOS_1 in  "SI" "NO"
do
	
	for EN_REPOS_0 in  "NO" "SI" 
	do
		
		for EN_NO_COPIAR in "NO" "SI"
		do
        
		REGLA_GT0="GT0_${EN_REPOS_1}_${EN_REPOS_0}_${EN_NO_COPIAR}"
		REGLA_EQ0="EQ0_${EN_REPOS_1}_${EN_REPOS_0}_${EN_NO_COPIAR}"
		
		let TOT_GT0=${TOT_GT0}+${CONT_ESTADO[${REGLA_GT0}]:-0}
		let TOT_EQ0=${TOT_EQ0}+${CONT_ESTADO[${REGLA_EQ0}]:-0}
		
		case ${COLORES} in 
			TRUE )
			printf "${FMT1}"	"${TITULO_F[${REGLA_GT0}]:---N/D---}"  \
								${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR} ${CONT_ESTADO[${REGLA_GT0}]:-0}  \
								"${TITULO_F[${REGLA_EQ0}]:---N/D---}" 	\
								${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR}  ${CONT_ESTADO[${REGLA_EQ0}]:-0}
			;;
			FALSE )
			printf "${FMT2}"	"${TITULO_F_NC[${REGLA_GT0}]}"  \
								${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR} ${CONT_ESTADO[${REGLA_GT0}]:-0}  \
								"${TITULO_F_NC[${REGLA_EQ0}]}" 	\
								${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR}  ${CONT_ESTADO[${REGLA_EQ0}]:-0}
			;;
		esac
		
		done
	done
done


printf  "\n%27s   %7s    %29s %7s\n\n" "TOT_GT0=" ${TOT_GT0} "TOT_EQ0=" ${TOT_EQ0}


# Reporte de Acciones

printf "AGREGAR A ESTR TEMP: %5s\n"   ${AGR_A_ESTR_TEMP}
printf "NO ACCION          : %5s\n"   ${NO_ACCION}
printf "AGR_A_NO_COPIAR    : %5s\n"   ${AGR_A_NO_COPIAR}
printf "INFORMAR REVISAR   : %5s\n"   ${INF_REV}
printf "INF_REV_Y_NO_COPIAR:           %5s\n"   ${INF_REV_Y_NO_COPIAR}
printf "              Total= %5s\n\n" $[${AGR_A_ESTR_TEMP}+${NO_ACCION}+${AGR_A_NO_COPIAR}+${INF_REV}+${INF_REV_Y_NO_COPIAR}]

# printf "ESTABA_EN_REPOSIT 1: %5s\n"   ${ESTABA_EN_REPOSIT[1]}  #<----------- Remover Luego?
# printf "ESTABA_EN_REPOSIT 0: %5s\n\n" ${ESTABA_EN_REPOSIT[0]}  #<----------- Remover Luego?

# printf "EN_AMBOS_REP       : %5s\n"   ${EN_AMBOS_REP}
# printf "ESTABA_EN_ESTR_TEMP: %5s\n"   ${ESTABA_EN_ESTR_TEMP}
# printf "ESTABA_EN_NO_COPIAR: %5s\n"   ${ESTABA_EN_NO_COPIAR}
# printf "EQ0_Y_EN_REP       : %5s\n\n" ${EQ0_Y_EN_REP}

# printf "TAM_EQ0            : %5s\n"   ${TAM_EQ0} #<----------- Remover Luego?
# printf "TAM_GT0            : %5s\n\n" ${TAM_GT0} #<----------- Remover Luego?

# Resumen tipos y casos

printf "TOT Tipo Foto      : %5s\n"	  ${Tipo_Foto}
printf "TOT Tipo Video     : %5s\n\n" ${Tipo_Video}

printf "                 Procesados       Agregados a ET\n"
printf "Casos Canon    : %5s               %5s\n"		${Tot_Tipo_Canon} 		${Tipo_Canon}
printf "Casos General  : %5s               %5s\n"		${Tot_Tipo_General} 	${Tipo_General}
printf "Casos Otra_cosa: %5s               %5s\n\n"		${Tot_Tipo_Otra_Cosa} 	${Tipo_Otra_Cosa}
printf "TOT Det por fecha  : %5s\n\n"	${Det_por_fecha}

fi

#------------------------------------------------------------------------
# Para a_nc
#------------------------------------------------------------------------

if [ ${COMANDO_COMPLETO} = "Gen_list_files_cel_NO_copiar" ]  || [ ${COMANDO_COMPLETO} = "a_nc" ] # 1 
then
printf "Generado por     : %s \n" 	$0 
printf "          Reporte: %s \n" 	"${RUN_DATE}"
printf "Directorio Origen: %s \n\n" ${DIR_FILES_COPIADOS_DEL_CEL}

printf "Tiempo generac Estr Temp: %5s seg\n"    $[${Tfin_estr_temp:-0}-${Tinicio_estr_temp:-0}]	
printf "Tiempo total ejecucion  : %5s seg\n\n"  $[${Tfin_estr_temp:-0}-${Tinicio:-0}]

printf "TOT_FILES_DEL_CEL  : %5s\n"   ${TOT_FILES_DEL_CEL}
printf "TOT_ESPUREOS_CEL   : %5s\n\n" ${TOT_ESPUREOS_CEL}

let TOT_GT0=0
let TOT_EQ0=0

printf "                          GT0                                   EQ0\n"
printf "%-10s      %3s %3s %3s %3s %5s  %-10s      %3s %3s %3s %3s %5s\n" "Estado" "R1" "R0" "N/C" "E/T" "CANT" "Estado" "R1" "R0" "N/C" "E/T" "CANT"
FMT1="%-26b %3s %3s %3s %3s %6s %-26b %3s %3s %3s %3s %6s\n"
FMT2="%-15s %3s %3s %3s %3s %6s %-15s %3s %3s %3s %3s %6s\n"

for EN_REPOS_1 in  "SI" "NO"
do
	
	for EN_REPOS_0 in  "NO" "SI" 
	do
		
	 for EN_NO_COPIAR in "NO" "SI"
	 do
      for EN_ESTR_TEMP in "NO" "SI"
	  do
		REGLA_GT0="GT0_${EN_REPOS_1}_${EN_REPOS_0}_${EN_NO_COPIAR}_${EN_ESTR_TEMP}"
		REGLA_EQ0="EQ0_${EN_REPOS_1}_${EN_REPOS_0}_${EN_NO_COPIAR}_${EN_ESTR_TEMP}"
		
		let TOT_GT0=${TOT_GT0}+${CONT_ESTADO[${REGLA_GT0}]:-0}
		let TOT_EQ0=${TOT_EQ0}+${CONT_ESTADO[${REGLA_EQ0}]:-0}

		case ${COLORES} in 
		TRUE )
		printf "${FMT1}"	"${TITULO_G[${REGLA_GT0}]}"  \
							${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR} ${EN_ESTR_TEMP} ${CONT_ESTADO[${REGLA_GT0}]:-0}  \
							"${TITULO_G[${REGLA_EQ0}]}" 	\
							${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR} ${EN_ESTR_TEMP} ${CONT_ESTADO[${REGLA_EQ0}]:-0} 
		;;
		FALSE )
		printf "${FMT2}"	"${TITULO_G_NC[${REGLA_GT0}]}"  \
							${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR} ${EN_ESTR_TEMP} ${CONT_ESTADO[${REGLA_GT0}]:-0}  \
							"${TITULO_G_NC[${REGLA_EQ0}]}" 	\
							${EN_REPOS_1} ${EN_REPOS_0} ${EN_NO_COPIAR} ${EN_ESTR_TEMP} ${CONT_ESTADO[${REGLA_EQ0}]:-0} 		
		;;
		esac
	   done
	  done
	done
done

printf  "\n%27s    %7s  %29s %7s\n" "TOT_GT0=" ${TOT_GT0} "TOT_EQ0=" ${TOT_EQ0}

printf "NO ACCION          : %5s\n"   ${NO_ACCION}
printf "AGR_A_NO_COPIAR    : %5s\n"   ${AGR_A_NO_COPIAR}
printf "INFORMAR REVISAR   : %5s\n"   ${INF_REV}
printf "INF_REV_Y_NO_COPIAR:           %5s\n"   ${INF_REV_Y_NO_COPIAR}
printf "              Total= %5s\n\n" $[${AGR_A_ESTR_TEMP}+${NO_ACCION}+${AGR_A_NO_COPIAR}+${INF_REV}+${INF_REV_Y_NO_COPIAR}]

# printf "ESTABA_EN_REPOSIT 1: %5s\n"   ${ESTABA_EN_REPOSIT[1]}
# printf "ESTABA_EN_REPOSIT 0: %5s\n\n" ${ESTABA_EN_REPOSIT[0]}

# printf "EN_AMBOS_REP       : %5s\n"   ${EN_AMBOS_REP}
# printf "ESTABA_EN_ESTR_TEMP: %5s\n"   ${ESTABA_EN_ESTR_TEMP}
# printf "ESTABA_EN_NO_COPIAR: %5s\n"   ${ESTABA_EN_NO_COPIAR}
# printf "EQ0_Y_EN_REP       : %5s\n\n" ${EQ0_Y_EN_REP}

# printf "TAM_EQ0            : %5s\n"   ${TAM_EQ0}
# printf "TAM_GT0            : %5s\n\n" ${TAM_GT0}

printf "TOT Tipo Foto      : %5s\n"	  ${Tipo_Foto}
printf "TOT Tipo Video     : %5s\n\n" ${Tipo_Video}

fi
return
}
#------------------------------------------------------------------------



