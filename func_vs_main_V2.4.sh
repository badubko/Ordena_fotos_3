#!/bin/bash
# 2.25 08/08/18 14:00:09    Creada la separacion de variables del main
# 							por esterica para que inicializar contadores no quede
#							en el medio
#--------------------------------------------------------------------------------
caso_canon_u_otra_cosa ()
#-------------------------------------------------------------------------------
{
# Caso Canon, Canon like  y otros achivos que no tengan fecha en el nombre...
# Separamos en tipo FOTO y VIDEO solo para preveer que se tenga q usar algun otro metodo para obtener la fecha.

# echo "${FNAME}  es Canon like u otra cosa "

	
	     #  Si ya habiamos obtenido la fecha al comparar files
	     #  ya tenemos  2017-04-25_HH:MM:SS porque se tuvo que recurrir a comparar fechas; 
		 #  recortamos solo la fecha

		if [ ${Fecha_file_cel} =  "0"  ]          
		then
			# Si no tenemos fecha, obtenerla.
			Fecha_file_cel="$( obtener_fecha ${FNAME_FULL} )"				
		fi
		if [ ${Fecha_file_cel} =  "????" ]	
		then
		    Dir_dest="Sin_Fecha"
		else     
            Dir_dest="${Fecha_file_cel%_*}"
        fi
       
return
}

#-------------------------------------------------------------------------------
caso_general ()
#-------------------------------------------------------------------------------
{
# echo "Es de los generales sacar fecha del nombre"

grep -q -e "$str_12\|$str_14\|$str_15" <<<${FNAME}
 if [ $? = "0" ]
 then
	Dir_dest=$( /bin/sed 's/^\([0-9]\{4\}\)\([0-9]\{2\}\)/\1-\2-/' <<<${FNAME} )
	Dir_dest=${Dir_dest:0:10} 
 else
	# Eliminar prefijo tipo IMG, DSCN, etc ; convertir a AAAA-MM-DD y quedarnos con esos primeros 10 caract
	#  Dir_dest=$( /bin/sed "$str_sustit" <<<${FNAME} |  /bin/sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)/\1-\2-/' | /usr/bin/cut -c1-10)
    #  Dir_dest=$( /bin/sed "$str_sustit" <<<${FNAME} |  /bin/sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)/\1-\2-/' )
    Dir_dest=$( /bin/sed -e "$str_sustit" -e 's/\([0-9]\{4\}\)\([0-9]\{2\}\)/\1-\2-/' <<<${FNAME}  )
    Dir_dest=${Dir_dest:0:10} 
 fi


return
}

#-------------------------------------------------------------------------------
obtener_dir_dest ()
#-------------------------------------------------------------------------------
{
  case ${TIPO_NOM_ARCH} in
  CANON )
	let Tipo_Canon++  	   
	caso_canon_u_otra_cosa	#--------->>>#
  ;;
  OTRA_COSA )
	let Tipo_Otra_Cosa++
	caso_canon_u_otra_cosa	#--------->>>#
  ;;
  GENERAL )
	let Tipo_General++	
	caso_general			#--------->>>#
  ;;
  esac

return
}

#-------------------------------------------------------------------------------
agregar_a_estr_temp ()
#-------------------------------------------------------------------------------
{
obtener_dir_dest
	if [ ! -d "$ESTR_TEMP/$Dir_dest" ]
	then
	  mkdir "$ESTR_TEMP/$Dir_dest"
	fi

#		     echo "$ESTR_TEMP/$Dir_dest/$FNAME"
#		     echo
		     
	 case ${TIPO_ARCH} in
	 FOTO )
	   cp -p $FNAME_FULL "$ESTR_TEMP/$Dir_dest/$FNAME"
	 ;;
	 VIDEO )
	   echo "cp -p ${FNAME_FULL} ${ESTR_TEMP}/${Dir_dest}/${FNAME}"  >>${WORK_SCRIPT_VID}
	 ;;
	 * )
	   echo  "${NOM_ABREV}: Paranoia check ${FNAME} tipo no previsto ${TIPO_ARCH}" 
	 ;;
	 esac               

# Limpiar variables para la proxima vuelta, para cuando se determine el tipo de arch
# tempranamente en buscar_en_repositorio
return
}
#-------------------------------------------------------------------------------
informar_revisar ()
{

#  Hasta tanto no se implemente el contador
   echo "${NOM_ABREV}: ${INF_REV} ${FNAME} ${REGLA}    ---> Informar/Revisar" >>${ARCHIVO_LOG}
   
   printf "\n" 													>>$ARCHIVO_LOG

return
}
#-------------------------------------------------------------------------------
agregar_a_no_copiar()
{
# Unificar formato con informar_revisar
#  
# En todos los casos de Fotos_cel_a_Estr_Temp el Tamaño sera "0" y la fecha "????"
# debido a que SOLAMENTE se agregan a N/C los archivos de tamaño=0
#
# La siguiente es la linea de a_et_main original
# printf "%s  %s  %s  %s\n" ${FNAME} ${Tam_file_cel} "????" "# ${AGR_A_NO_COPIAR}  ${REGLA}  ${NOM_ABREV} ${RUN_DATE}" >>$LISTA_FILES_NO_COPIAR
#
# Estas lineas vienen de a_nc_main
if [ "${Fecha_file_cel}" = "0" ]  #3
then
    if [ ${TIPO_NOM_ARCH} = "GENERAL" ] #2
    then
		Fecha_file_cel="En_Nombre"
    else   	#2
        if [ ${TAM} = "GT0" ] #1
        then
			Fecha_file_cel="$( obtener_fecha ${FNAME_FULL} )" #--------->>>#
	    else #1
			Fecha_file_cel="????"
		fi  #1
	fi	#2
fi #3

printf "%s  %s  %s  %s\n" ${FNAME} ${Tam_file_cel} ${Fecha_file_cel} "# ${REGLA}  ${NOM_ABREV} ${RUN_DATE}" >>${LISTA_FILES_NO_COPIAR}

return
}
