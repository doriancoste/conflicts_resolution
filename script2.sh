#!/bin/bash
#des parametres sont des noms des fichiers 
#save the result in one document "result"
if [[ $# -eq 0 ]]
then
	echo "Erreur: il faut au moins 1 parametre"
fi

for i in "$@"
do  
./script1.sh $i "if"  "bnb" "naive" >> result
done
