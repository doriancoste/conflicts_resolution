#!/bin/bash
#1ème parametre doit est cluster_*ac_*err_*.txt"
#2ème parametre doit est 'if' ou 'pas_if'" 
#3ème parametre doit est 'bnb' ou 'ac3'" 
#4ème parametre doit est 'naive' ou 'mij'" 
# return la résultat de la command "./conflicts_resolution -n $n -e $e -r $r $2 $3 $4" sur la sortie standard

if [[ $# -ne 4 ]]
then
	echo "Erreur: mauvais nombre de parametre"
	echo "1ème parametre doit est cluster_*ac_*err_*.txt"
	echo "2ème parametre doit est 'if' ou 'pas_if'" 
	echo "3ème parametre doit est 'bnb' ou 'ac3'" 
	echo "4ème parametre doit est 'naive' ou 'mij'" 
	exit 1
fi
   

declare -i n=5 #int : nombre d'avion (5 par defaut)
declare -i e=1 #int: nombre d'erreur (1 par defaut)
declare -i r=0 #int: graine (0 par defaut)


let new_n=`echo $1 | cut -d _ -f 2 |grep -o [[:digit:]]*` #nombre d'avion
let new_e=`echo $1 | cut -d _ -f 3 |grep -o [[:digit:]]*` #nombre d'erreur
let new_r=`echo $1 | cut -d _ -f 4 |grep -o [[:digit:]]*` #graine
if [[ new_n != '' ]]
then
	let n=new_n
fi
if [[ new_e != '' ]]
then
	let e=new_e
fi
if [[ new_r != '' ]]
then
	let r=new_r
fi

#echo $n $e $r #test

if [[ $2 != "if" && $2 != "pas_if" ]]
then
	echo "Erreur: 2ème parametre doit est 'if' ou 'pas_if'" 
	exit 1
fi
if [[ $3 != "bnb" && $3 != "ac3" ]]
then
	echo "Erreur: 3ème parametre doit est 'bnb' ou 'ac3'" 
	exit 1
fi
if [[ $4 != "naive" && $4 != "mij" ]]
then
	echo "Erreur: 4ème parametre doit est 'naive' ou 'mij'" 
	exit 1
fi

./conflicts_resolution -n $n -e $e -r $r $2 $3 $4

