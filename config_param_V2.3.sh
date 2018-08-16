#! /bin/bash
# config_param crea a partir de datos_parametros la funcion
# carga_parametros
# 
# 


linea_guiones ()
{
echo "#----------------------------------------------------------------"  
}

configura_parametros ()
{

# declare -A CP_LISTA_VARIABLES CP_IN_FILE CP_OUT_FILE

LISTA_VARIABLES="REPOS_A_CONS= \
					REGEN_LISTA_FILES_REP\[1\]= \
					REGEN_LISTA_FILES_REP\[0\]= \
					SOLO_REGEN_LISTA_FILES_REP\[1\]= \
					SOLO_REGEN_LISTA_FILES_REP\[0\]= \
					REPOSITORIO\[0\]= \
					REPOSITORIO\[1\]= \
					PREFIJO\[0\]= \
					PREFIJO\[1\]= \
					LISTA_DIRS\[0\]= \
					LISTA_DIRS\[1\]= \
					WORK_DIR= \
					LISTA_FILES_REP\[0\] \
					LISTA_FILES_REP\[1\] \
					PATRON_DIR_MINIAT_CGATE= \
					NOM_CEL= \
					DIR_FILES_COPIADOS_DEL_CEL= \
					ESTR_TEMP= \
					LISTA_FILES_ESTR_TEMP= \
					SUB_DIR_NO_COPIAR= \
					LISTA_FILES_NO_COPIAR= \
					ARCHIVO_LOG= \
					WORK_SCRIPT_VID= \
					LISTAR_MODULOS= \
					GENERAR_REP_T_PARC= \
					REPORTA_HALLADO_EN_NC= \
					REPORTE_DEL_ZIP="



CP_IN_FILE="datos_parametros_V${VERS_MODS}.sh"
CP_OUT_FILE="carga_parametros_V${VERS_MODS}.sh"

if [ ! -f  "${INSTALL_DIR}/${CP_IN_FILE}" ]
then
	echo "El Archivo ${INSTALL_DIR}/${CP_IN_FILE} NO existe"
	exit
fi


RUN_DATE="$(date  +\#\ %Y\/%m\/%d\ %H:%M)"
RUN_DATE_FILE="$(date  +%Y-%m-%d_%H%M)"  

# En que branch estamos?

git status >/dev/null
if [ $? = "0" ]
then
	BRANCH=$( git branch --list --no-color | grep  "\* ")
	BRANCH="${BRANCH:2}"
else
    BRANCH="NO-git"
fi

# DIR_REF=${HOME}"/Documents/Ordena_Fotos_Cel" # Esto tal vez deberia referirse
#											 # a $PWD...
DIR_REF=${PWD}
FLAG_TERM="FALSE"           # Si algun parametro no esta definido terminar temprano

if [ ! -f "${CP_IN_FILE}" ]
then
	echo "El archivo: ${CP_IN_FILE} No existe..."
	exit
fi


if [  -d "${CP_OUT_FILE}" ]
then
  echo "${NOM_ABREV}: No se puede generar: ${CP_OUT_FILE} Es un directorio"
  exit
fi

if [  -f "${CP_OUT_FILE}" ]
then
	rm -f "${CP_OUT_FILE}"
fi

#
# Aca viene el banner y la lista de variables a incluir

  echo "#! /bin/bash"									 >${CP_OUT_FILE}
  linea_guiones 										>>${CP_OUT_FILE}
  
  echo "# Nombre    :  ${CP_OUT_FILE}"					>>${CP_OUT_FILE}
  echo "# Creado por: $0     Run_date  : ${RUN_DATE}"	>>${CP_OUT_FILE}
  echo "# Branch    :  ${BRANCH}"				>>${CP_OUT_FILE}
  printf "\n"											>>${CP_OUT_FILE}
  echo "# Directorio Origen:  ${PWD}"  					>>${CP_OUT_FILE}
  echo "# IN_FILE :  datos_parametros_V${VERS_MODS}.sh"	>>${CP_OUT_FILE}
  linea_guiones 										>>${CP_OUT_FILE}
  echo "# Warning   : DO NOT EDIT THIS FILE !!!"		>>${CP_OUT_FILE}
  linea_guiones 										>>${CP_OUT_FILE}
  echo "carga_parametros () {"							>>${CP_OUT_FILE}
  printf "\n"											>>${CP_OUT_FILE}
  echo "# Variables incluidas:"				  	        >>${CP_OUT_FILE}
  
#  echo ${LISTA_VARIABLES}
  
  for VARS_A_INCLUIR in ${LISTA_VARIABLES}
  do
#	echo "A incluir: ${VARS_A_INCLUIR} "
     grep -v '^#.*' ${CP_IN_FILE} | grep  '\<'"${VARS_A_INCLUIR}" 	>>${CP_OUT_FILE}
     if [ $? != 0 ]
     then
		FLAG_TERM="TRUE"
		echo "# -----> Variable NO definida: ${VARS_A_INCLUIR} "	>>${CP_OUT_FILE}
	 fi	
     printf "\n"												>>${CP_OUT_FILE}
     
#		printf "#                     %s\n" ${VARS_A_INCLUIR} 	>>${CP_OUT_FILE}
  done

echo "}"												>>${CP_OUT_FILE}
linea_guiones 											>>${CP_OUT_FILE}
printf "\n\n"											>>${CP_OUT_FILE}

if [ ${FLAG_TERM} = "TRUE" ]
then
	printf "\n"
	echo "Variable NO definida. Terminacion temprana"
	exit
fi

# Le sacamos permiso de w para que nadie edite este file
chmod 444 ${CP_OUT_FILE}

}

