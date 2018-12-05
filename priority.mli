val get_priority_1 : Modele.t -> int array -> int
(**Calcule la priorite associee à l'objet t a partir de la liste des couts
   noeud s : type t
   liste des couts cost : int array
   valeur de retour : priorité: int

   Dans cette fonction, la priorite est definie comme etant la somme des min(xi), xi appartement a compatibles_maneuvers.(i)
 **)
