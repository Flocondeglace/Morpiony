extends Node2D

## Contiendra la liste des cases voisines à une case déjà prises par le joueur 
var hasneighbour = []
var num_player : int
var cases_disponibles
var morpions_disponibles
## Case que le joueur va jouer
var choix
var liste_choix

func play_strat_stupide():
	return play_random(cases_disponibles)

func play_strat_attaque():
	hasneighbour = []
	liste_choix = []
	push_warning("Attaque")
	liste_choix = play_attack()
	if liste_choix == []:
		push_warning("Defense")
		liste_choix = play_def()
	if liste_choix == []:
		push_warning("Voisin")
		liste_choix = hasneighbour
	if liste_choix == []:
		push_warning("Aleatoire")
		liste_choix.append(play_random(cases_disponibles))
	return play_random_list(liste_choix)
	

func play(vnum_player,morp,dispo,morplegal):
	num_player = vnum_player
	cases_disponibles = dispo
	morpions_disponibles = morplegal
	choix = null
	# stupide
	# choix = play_strat_stupide()

	# semi smart attaque
	choix = play_strat_attaque()
	
	click(choix)
	

func play_random(dispo):
	return dispo.pick_random().pick_random()

func play_random_list(dispo):
	return dispo.pick_random()
	
func click(case):
	case.set_piece(num_player)

func play_attack():
	var liste_choix_attack = []
	for mini in morpions_disponibles:
		liste_choix_attack += play_attack_mini(num_player,mini.minimorp,true)
	return liste_choix_attack

func play_def():
	var liste_choix_def = []
	for mini in morpions_disponibles:
		liste_choix_def += play_def_mini(mini.minimorp)
	return liste_choix_def

func play_attack_mini(numPlayer,cases,conservation_voisins):
	var liste_propositions = []
	var wincases = cases.filter(func (case): return case.win == numPlayer)
	var freecases = cases.filter(func (case): return case.win == 0)
	var wincases_ord_line = []
	var freecases_ord_line = []
	var wincases_ord_column = []
	var freecases_ord_column = []
	var freediag1 = freecases.filter(func (case): return case.pos in [0,4,8])
	var windiag1 = wincases.filter(func (case): return case.pos in [0,4,8])
	var freediag2 = freecases.filter(func (case): return case.pos in [2,4,6])
	var windiag2 = wincases.filter(func (case): return case.pos in [2,4,6])
	
	if (freediag1.size() == 1 && windiag1.size()==2):
		liste_propositions.append(freediag1[0])
	if (freediag2.size() == 1 && windiag2.size()==2):
		liste_propositions.append(freediag2[0])
	
	var k : int = 3
	for i in range (0,3):
		wincases_ord_column.append(wincases.filter(func (case): return case.pos%k == i))
		wincases_ord_line.append(wincases.filter(func (case): return case.pos/k == i))
		freecases_ord_column.append(freecases.filter(func (case): return case.pos%k == i))
		freecases_ord_line.append(freecases.filter(func (case): return case.pos/k == i))
	for i in range (0,3):
		if (wincases_ord_line[i].size() == 2 && freecases_ord_line[i].size() == 1):
			push_warning("liiigne "+ str(i)+ " vpos : "+str(freecases_ord_line[i][0].pos))
			liste_propositions.append(freecases_ord_line[i][0])
		if (wincases_ord_column[i].size() == 2 && freecases_ord_column[i].size() == 1):
			push_warning("colooone "+ str(i)+ " vpos : " + str(freecases_ord_column[i][0].pos))
			liste_propositions.append(freecases_ord_column[i][0])
		if conservation_voisins :
			if (wincases_ord_line[i].size()==1 && freecases_ord_line[i].size()>=1):
				hasneighbour.append_array(freecases_ord_line[i])
			if (wincases_ord_column[i].size()==1 && freecases_ord_column[i].size()>=1):
				hasneighbour.append_array(freecases_ord_column[i])
	return liste_propositions


func play_def_mini(cases):
	return play_attack_mini(num_player%2 +1, cases,false)
	
