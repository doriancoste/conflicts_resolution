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
	for e in 1
	do
		for r in 1 2 3 4 5 6 7 8 9
		do
			#echo "n=$n e=$e r=$r" >> result
			if [ $1 = "pas_fi" ]
			then
				./conflicts_resolution -n $n -e $e -r $r -fi -m $2 -b $3 >> result
			else
				./conflicts_resolution -n $n -e $e -r $r -m $2 -b $3 >> result
			fi
		done

	done
done
