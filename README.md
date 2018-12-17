# conflicts_resolution

# ************* OPTIONS DE LANCEMENT ************* #
# -n : nombre d'avion (5 par defaut)
# -e : nombre d'erreur (1 par defaut)
# -r : graine (0 par defaut)
# -b : borne a utiliser. Au choix "naive" pour la borne naive (par defaut) ou "mij" pour celle utilisant les mij
# -m : methode a utiliser (filtre). Au choix "bandb" pour le branch and bound (par defaut) ou "ac3" pour ac3


# ************* A FAIRE ************* #
# 1- Essayer d'améliorer filter_ac3 avec un List.filter ?
# 4- 3ieme algo pour la borne
# 5- Faire un filtre initial sur ac3 qui a s0->s0s_no_filtered -> Sam

# 6- Vérifiez qu'une des variables du domaine n'est pas vide avant d'ajouter le nouveau "s" à la file; -> Zhen

# ************* ATTENTION ************* #
# - Pensez à remplir le .mli quand vous ajoutez une fonction au fichier correspondant
# - Ne pas push sur le git du code qui ne compile pas
# - Penser au fonctionnement des fonctions utilisées (modification en place, type de structure, egalite physique)
