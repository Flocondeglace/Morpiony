extends Node2D

var hasneighbour = []

func play(numPlayer,morp,dispo,morplegal):
	# stupide
	#var case = dispo.pick_random().pick_random()#dispo[randi_range(0, dispo.size()-1)]
	#case.emit_signal("pressed")
	
	var choix
	hasneighbour = []
	# semi smart attaque
	for minimorplegal in morplegal:
		choix = play_align_3(numPlayer,minimorplegal.minimorp,true)
		if choix != null:
			break
	if choix == null:
		for minimorplegal in morplegal:
			choix = play_def(numPlayer,minimorplegal.minimorp)
	if choix==null:
		choix = play_next_to(hasneighbour)
	if choix == null:
		choix = play_random(dispo)
	click(numPlayer,choix)
	

func play_random(dispo):
	return dispo.pick_random().pick_random()

func play_random_list(dispo):
	return dispo.pick_random()
	
func click(numPlayer,case):
	case.set_piece(numPlayer)
	#case.emit_signal("pressed")

# Prends en entrée la liste des cases dispo à côté desquelles il y a une case de rempli gagnante
func play_next_to(dispo):
	play_random_list(dispo)
	

func play_align_3(numPlayer,cases,conservation_voisins):
	push_warning("biiis")
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
		return freediag1[0]
	if (freediag2.size() == 1 && windiag2.size()==2):
		return freediag2[0]
	
	var k : int = 3
	for i in range (0,2):
		wincases_ord_column.append(wincases.filter(func (case): return case.pos%k == i))
		wincases_ord_line.append(wincases.filter(func (case): return case.pos/k == i))
		freecases_ord_column.append(freecases.filter(func (case): return case.pos%k == i))
		freecases_ord_line.append(freecases.filter(func (case): return case.pos/k == i))
	for i in range (0,2):
		if (wincases_ord_line[i].size() == 2 && freecases_ord_line[i].size() == 1):
			push_warning("liiigne")
			return freecases_ord_line[i][0]
		if (wincases_ord_column[i].size() == 2 && freecases_ord_column[i].size() == 1):
			push_warning("colooonne")
			return freecases_ord_column[i][0]
		if conservation_voisins :
			if (wincases_ord_line[i].size()==1 && freecases_ord_line[i].size()>=1):
				hasneighbour.append_array(freecases_ord_line[i])
			if (wincases_ord_column[i].size()==1 && freecases_ord_column[i].size()>=1):
				hasneighbour.append_array(freecases_ord_column[i])
	return null


func play_def(numPlayer,cases):
	play_align_3(numPlayer%2 +1, cases,false)
