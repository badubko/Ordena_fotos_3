#!/bin/bash
#  Version:    	2.2 06/08/18 15:43:12
#              	Se crea este modulo 



que_vers_de_param_incluir ()
{

VERS_PARAM=
# PARMS_A_INCLUIR=carga_parametros_V2.2.sh		# <-----  <MODIFICABLE>

PARMS_A_INCLUIR=XYZPARAMETROSXYZ

if [ ! -f  "${INSTALL_DIR}/${PARMS_A_INCLUIR}" ]
then
	echo "El MODULO ${INSTALL_DIR}/${PARMS_A_INCLUIR} NO existe"
	exit
fi


return
}
