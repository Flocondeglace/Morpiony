extends Node

var minimorp_temp = preload("res://Scene/mini_morpion.tscn") 
var nbHumanPlayer
var player_turn = 1
var morp = []
var morpdispo = []

## Couleur fond

# Couleur normal
# var couleur = [Color(Color.CADET_BLUE,1),Color(Color.ROSY_BROWN,1)]

# Couleur halloween
var couleur = [Color(Color.CORAL,0.4),Color(Color.DIM_GRAY,1)]

var hud
var current_player_rect
var resultat_morpion
# position du morpion dans lequel le joueur doit jouer
var pos
var case

func _ready():
	hud = $HUD/Control/HUDcanva
	current_player_rect = $HUD/Control/HUDcanva/CurrentPlayer
	resultat_morpion = $HUD/Control/HUDcanva/ResultatMorpion


func _process(delta):
	if Input.is_action_pressed("escape"):
		get_tree().quit()
		
	if hud.state == "game":
		if Input.is_action_pressed("player1") && player_turn == 1:
			#push_warning($BigMorpion.get_viewport().gui_get_focus_owner().name)
			$BigMorpion.get_viewport().gui_get_focus_owner()._on_pressed()
		if Input.is_action_pressed("player2") && player_turn == 2:
			$BigMorpion.get_viewport().gui_get_focus_owner()._on_pressed()
	
		
func new_game(nbPlayer):
	clear_game()
	morp = []
	nbHumanPlayer = nbPlayer
	player_turn = 1
	var compteur = 0
	for i in range (0,3):
		for j in range(0,3):
			var minimorp = minimorp_temp.instantiate()
			#minimorp.get_child(1).num = compteur
			minimorp.num = compteur
			minimorp.nbHuman = nbHumanPlayer
			#morp[i].append(minimorp.get_child(1))
			morp.append(minimorp)
			$BigMorpion.add_child(minimorp)
			morp[3*i + j].minimorpion_played.connect(_on_mini_morpion_minimorpion_played)
			compteur +=1
	morp[0].minimorp[0].grab_focus()
	case = morp[0].minimorp[0].case
	current_player_rect.set_texture(case[player_turn])
	let_all_choices()

func game_finished(num_winner):
	hud.state = "gameover"
	#hud.game_over()
	var timerFin = Timer.new()
	add_child(timerFin)
	timerFin.start(3)
	await timerFin.timeout
	timerFin.queue_free()
	#resultat_morpion.add_child($BigMorpion)
	for ch in $BigMorpion.get_children() :
		$BigMorpion.remove_child(ch)
		resultat_morpion.add_child(ch)
	resultat_morpion.show()
	hud.end_of_game(num_winner)
	

func let_all_choices():
	for m in morp:
		if m.win == 3:
			m.start_turn(player_turn)
			push_warning(str(m.num) + " : pos all choices")
			morpdispo.append(m)

func let_none_choices():
	for m in morp:
		m.finish_turn()
		
func change_player():
	player_turn = 1 + player_turn%2
	current_player_rect.set_texture(case[player_turn])

func computer_play():
	var liste = []
	for mini in morpdispo:
		#push_warning(str(mini.num))
		liste.append(mini.cdispo)
	var choice = $Computer.play(player_turn,morp, liste,morpdispo)

func computer_thinking():
	if (nbHumanPlayer == 1 && player_turn == 2):
		var think_timer = Timer.new()
		add_child(think_timer)
		think_timer.start(0.5)
		await think_timer.timeout
		think_timer.queue_free()
		computer_play()
	

func _on_mini_morpion_minimorpion_played(played,pos):
	var morp_played = morp[played]
	morpdispo = []
	morp_played.check_winner()
	#push_warning(played)
	if (morp_played.win != 3):
		push_warning('wiiiin')
	change_player()
	
	change_color()
	let_none_choices()
	if (morp[pos].win!=3) :
		let_all_choices()
	else :
		morpdispo.append(morp[pos])
		morp[pos].start_turn(player_turn)
	
	if (check_winner_big(1)):
		push_warning("player 1 win")
		game_finished(1)
	elif (check_winner_big(2)):
		push_warning("player 2 win")
		game_finished(2)
	elif (check_egalite_big()):
		push_warning("egaliteeeeeeeeeeeeeeeeee")
		game_finished(0)
	else:
		computer_thinking()
		#computer_play()

func change_color():
	$ColorRect.color = couleur[player_turn - 1]

func check_egalite_big():
	var complet = 0
	for m in morp:
		if (m.win != 3):
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

func clear_game():
	for ch in $BigMorpion.get_children():
		$BigMorpion.remove_child(ch)

func _on_hud_return_menu():
	clear_game()
