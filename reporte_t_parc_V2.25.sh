#! /bin/bash



reporte_t_parc ()
{

printf "REPORTE DE Tiempos Parciales \n\n"

printf "%-35s:  %6s\n" "Verif_dirs_y_files:"  ${ACUM_TIEMPOS[Verif_dirs_y_files]}

printf "%-35s:  %6s\n" "ACUM_TIEMPOS ET"    ${ACUM_TIEMPOS[ET]}

printf "%-35s:  %6s\n" "ACUM_TIEMPOS FILES_DEL_CEL" ${ACUM_TIEMPOS[FILES_DEL_CEL]}

printf "%-35s:  %6s\n" "ACUM_TIEMPOS FULL" ${ACUM_TIEMPOS[FULL]}

printf "%-35s:  %6s\n\n" "TIEMPO TOTAL" $[${ACUM_TIEMPOS[Verif_dirs_y_files]}+${ACUM_TIEMPOS[ET]}+${ACUM_TIEMPOS[FILES_DEL_CEL]}+${ACUM_TIEMPOS[FULL]}]


printf "%-36b:  %6s\n" "ACUM_TIEMPOS Determ Tamaño" ${ACUM_TIEMPOS[TAM]}

printf "%-35s:  %6s\n" "ACUM_TIEMPOS BUSCAR en REP" ${ACUM_TIEMPOS[BUSCAR_EN_REP]}

printf "%-35s:  %6s\n\n" "ACUM_TIEMPOS Buscar en NO COPIAR" ${ACUM_TIEMPOS[NO_COPIAR]}


return
}
