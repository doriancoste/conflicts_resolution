#!/bin/bash

if [[ $# -ne 3 ]]
then
	echo "Erreur: mauvais nombre de parametre"
	echo "1ème parametre doit est 'if' ou 'pas_if'"
	echo "2ème parametre doit est 'bnb' ou 'ac3'"
	echo "3ème parametre doit est 'naive' ou 'mij'"
	exit 1
fi


for n in 5 10 15
do
	case $n in
	"5" | "10" )
		e_list="1";;
	"15" | "20")
		e_list="1 2 3";;
	"25")
		e_list="1";;
	* )
		echo "Erreur n"
		exit 1
	esac
	for e in $e_list
	do
		for r in 0 1 2 3 4 5 6 7 8 9
		do
			#echo "n=$n e=$e r=$r" 
			if [ $1 = "pas_fi" ]
			then
				./conflicts_resolution -n $n -e $e -r $r -fi -m $2 -b $3 >> result
			else
				./conflicts_resolution -n $n -e $e -r $r -m $2 -b $3 >> result
			fi
		done

	done
done
