#!/bin/bash

rf="0"
for x in "$@"
do
    if [ $rf == "1" ]
    then
	fichier=$x
	break
    fi
    if [ "$x" == "-f" ]
    then
	rf="1"
    fi
done
df1="0"
for s in "$@"
do
 if [ $df1 == "2" ]
    then
	max=$s
	break
 fi
 if [ $df1 == "1" ]
    then
	min=$s
	df1="2"
    fi
    if [ "$s" == "-d" ]
    then
	df1="1"
    fi
done
 echo "$fichier" 

extractWind() { awk -F ";" '{print $1";"$2";"$3";"$15}'  lieu.csv > meteo_filtered_wind.csv ;}
extractTemp() { awk -F ";" '{print $1";"$2";"$11";"$15}' lieu.csv > meteo_filtered_temp.csv ;}
extractMoisture() { awk -F ";" '{print $1";"$2";"$6";"$15}' lieu.csv > meteo_filtered_moist.csv ;}
extractHeight() { awk -F ";" '{print $1";"$2";"$14";"$15}' lieu.csv > meteo_filtered_height.csv ;}
extractPress() { awk -F ";" '{print $1";"$2";"$3";"$15}' lieu.csv > meteo_filtered_press.csv ;}


while getopts "AGQOSFhfdmw:t:p:s:L:" option ; do
    case $option in
	d) awk -F ";" '$2 < "'$max'" && $2 > "'$min'"' $fichier >> meteo_date.csv ;;
	L) case $OPTARG in
	       F) awk -F ';' '$1 < 40349' meteo_date.csv >> lieu.csv ;;
	       A) awk -F ';' '$1 < 79000 && $1 > 70000' meteo_date.csv >> lieu.csv ;;
	       G) awk -F ';' '$1 < 88998 && $1 > 80001' meteo_date.csv >> lieu.csv ;;
	       Q) awk -F ';' '$1 == 89642' meteo_date.csv >> lieu.csv ;;
	       O) awk -F ';' '$1 < 67006 && $1 > 61000'meteo_date.csv >> lieu.csv ;; 
	       S) awk -F ';' '$1 == 71805' meteo_date.csv >> lieu.csv ;;
	       esac;;
     w) extractWind ;;
     m) extractMoisture ;;
     h) extractHeight ;;
     t) case $OPTARG in
	    1) extractTemp | echo "max" ;;
	    2) extractTemp | echo "min" ;;
	    3) extractTemp | echo "chrono" ;;
	esac;;
     p) case $OPTARG in
	    1) extractPress | echo "max" ;;
	    2) extractPress | echo "min" ;;
	    3) extractPress | echo "chrono" ;;
	esac;;
     s) case $OPTARG in
	    avl) ./tri.exe -avl ;;
	    abr) ./tri.exe -abr ;;
	    tab) ./tri.exe -tab ;;
	esac;;
    
	
 esac
done
