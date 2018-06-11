#! /bin/bash
#------------------------------------------------------------------------------
#	V1.6	21/09/17 16:52:07 Se crea esta funcion en file separado
#								A partir de la version en Gen_list...1.5
#	V1.7	21/10/17 10:47:55 Se modifica tratamiento de DIRECT considerando
#					contenido de variable INSTALL_DIR que se define en el main
#					Este es el directorio desde el cual se importan los modulos
# 					Esta version es primitiva ya que requiere que todos los modulos
#					Residan en INSTALL_DIR
#					MEJORAR algun dia...
#			23/10/17 00:17:48 Resuelto	(?)	
#			24/10/17 19:53:18 Corregido formato de impresion
#
#-------------------------------------------------------------------------------
listar_modulos ()
{
# Listar versiones de los modulos...
																					
LISTA_SRC=$(grep -e 'source' "$0" | grep -v grep | grep -v -e '#.*source.*' | sed -e 's/source //' -e 's/#.*//'  )
for LISTA_MODS in ${LISTA_SRC}
do
	 DIRECT=${LISTA_MODS%/*}
	 if [ ${DIRECT} = '${INSTALL_DIR}' ]
	 then
	   DIRECT=${INSTALL_DIR}
	 fi
	 
#	 echo "DIRECT1" "${DIRECT}"
#	 DIRECT=${DIRECT/\$\{/}
#    DIRECT=${DIRECT/\}/}	
#    echo "DIRECT2" ${DIRECT} ${!DIRECT}
#    DIRECT=${INSTALL_DIR}

	if [ "${DIRECT}" = '.' ]
	then
	  DIRECT=${PWD}
	fi  

	   VERS=${LISTA_MODS##*_}
	   VERS=${VERS%.*} 
	   MOD=${LISTA_MODS##*/}
	   MOD=${MOD%_V*}
	   printf "%-45s %-27s %-6s\n" ${DIRECT} ${MOD}  ${VERS} 
done
printf "\n\n"	
}
