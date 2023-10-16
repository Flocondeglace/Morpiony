extends Node

var minimorp_temp = preload("res://Scene/mini_morpion.tscn") 
var player_turn = 1
var morp = []

func _ready():
	pass

func new_game():
	#Positionnement
	morp = []
	player_turn = 1
	var compteur = 0
	for i in range (0,3):
		for j in range(0,3):
			var minimorp = minimorp_temp.instantiate()
			#minimorp.get_child(1).num = compteur
			minimorp.num = compteur
			#morp[i].append(minimorp.get_child(1))
			morp.append(minimorp)
			$BigMorpion.add_child(minimorp)
			morp[3*i + j].minimorpion_played.connect(_on_mini_morpion_minimorpion_played)
			compteur +=1
	let_all_choices()

func game_finished(num_winner):
	for ch in $BigMorpion.get_children() :
		$BigMorpion.remove_child(ch)
	$HUD.end_of_game(num_winner)
	

func let_all_choices():
	for m in morp:
		if m.win == 0:
			m.start_turn(player_turn)

func let_none_choices():
	for m in morp:
		m.finish_turn()

func _on_mini_morpion_minimorpion_played(played,pos):
	var morp_played = morp[played]
	morp_played.check_winner()
	push_warning(played)
	if (morp_played.win != 0):
		push_warning('wiiiin')
	player_turn = 1 + player_turn%2
	push_warning("player " + str(player_turn))
	let_none_choices()
	if (morp[pos].win!=0) :
		let_all_choices()
	else :
		morp[pos].start_turn(player_turn)
	if (check_egalite_big()):
		game_finished(0)
	elif (check_winner_big(1)):
		game_finished(1)
	elif (check_winner_big(2)):
		game_finished(2)

func check_egalite_big():
	var complet = 0
	for m in morp:
		if (m.win != 0):
			complet +=1
	if complet == 9 :
		return true
	return false
	
func check_winner_big(player):
	var ligne
	var colonne
	for i in range(0,3):
		ligne = 0
		colonne = 0
		for j in range(0,3):
			if (morp[i*3 + j].win == player):
				ligne +=1
			if (morp[j*3 + i].win == player):
				colonne +=1
		if (ligne == 3 || colonne == 3):
			return true
	var diag1 = 0
	var diag2 = 0
	for i in range (0,3):
		if (morp[i*3 + i].win == player):
			diag1 += 1
			
		if (morp[i*3 + 2-i].win == player):
			diag2 += 1

	if (diag1 == 3 || diag2 == 3):
		return true
	return false
