extends Node

var minimorp_temp = preload("res://Scene/mini_morpion.tscn") 
var nbHumanPlayer
var player_turn = 1
var morp = []
var morpdispo = []

@onready var big_morpion = $CenterContainer/BigMorpion
var galant : bool
var ia_turn : int = 2
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

@onready var choix_pions = $HUD/%ChoixPions
var noms = []
var logos = []
var actr : InputEventJoypadMotion
var actl : InputEventJoypadMotion
var actu : InputEventJoypadMotion
var actd : InputEventJoypadMotion
var joystick_events
var actions = ["ui_left", "ui_right", "ui_up", "ui_down"]

func _ready():
	hud = $HUD/Control/HUDcanva
	current_player_rect = $HUD/Control/HUDcanva/CurrentPlayer
	resultat_morpion = $HUD/Control/HUDcanva/ResultatMorpion
	
	actl = InputEventJoypadMotion.new()
	actl.axis = JOY_AXIS_LEFT_X
	actl.axis_value = -1.0
	
	actr = InputEventJoypadMotion.new()
	actr.axis = JOY_AXIS_LEFT_X
	actr.axis_value = 1.0
	
	actu = InputEventJoypadMotion.new()
	actu.axis = JOY_AXIS_LEFT_Y
	actu.axis_value = -1.0
	
	actd = InputEventJoypadMotion.new()
	actd.axis = JOY_AXIS_LEFT_Y
	actd.axis_value = 1.0
	
	joystick_events = [actl, actr, actu, actd]

func activate(device,b):
	for act in joystick_events:
		act.device = device
	
	for i in range(len(actions)):
		if b :
			InputMap.action_add_event(actions[i], joystick_events[i].duplicate())
		else :
			InputMap.action_erase_event(actions[i], joystick_events[i].duplicate())


func _input(event: InputEvent) -> void:
	
	if event.is_action_released("escape"):
		get_tree().quit()
	
	if hud.state == "game":
		if event.is_action_pressed("player1") && player_turn == 1:
			big_morpion.get_viewport().gui_get_focus_owner()._on_pressed()
			activate(0,false)
			activate(1, true)

		if event.is_action_pressed("player2") && player_turn == 2:
			big_morpion.get_viewport().gui_get_focus_owner()._on_pressed()
			activate(1,false)
			activate(0, true)
		if event.is_action_released("escape_game"):
			get_tree().quit()
	#else:
		#if event.is_action("my_accept"):
			#var fake_event = InputEventKey.new()
			#fake_event.keycode = KEY_ENTER  # Associer l'événement à la touche Enter
			#fake_event.pressed = true
			#Input.parse_input_event(fake_event)
			#
			## Simuler le relâchement de la touche
			#fake_event.pressed = false
			#Input.parse_input_event(fake_event)
			#print("accept")
			##Input.action_press("ui_accept")
			##print(Input.is_action_pressed("ui_accept"))
			##Input.action_release("ui_accept")
			

func choisir_pions():
	noms = []
	print("choix pions")
	hud.set_state("choix_pions")
	galant = false
	choix_pions.set_visible(true);
	hud.desact_button_game()
	for i in range(nbHumanPlayer):
		if i == 0 :
			choix_pions.changer_couleur(Color.BLUE)
		else:
			choix_pions.changer_couleur(Color.RED)
			
		choix_pions.changer_texte("Joueur " + str(i + 1),i==0)
			
		var nom = await choix_pions.joueurChoisi
		if i==0:
			galant = await choix_pions.galant
		noms.append(nom)
	if nbHumanPlayer == 1 :
		noms.append("Godot")
	export_to_logos()
	print("fin choix " + str(galant))
	choix_pions.set_visible(false)
	choix_pions.reset()
	hud.set_state("game")
	hud.act_button_game()

func export_to_logos():
	logos = []
	for n in noms:
		logos.append("res://Image/Pions/"+n.to_lower()+".png")

func new_game(nbPlayer):
	print("newgame")
	nbHumanPlayer = nbPlayer
	await choisir_pions()
	
	print("first :" + str(galant))
	clear_game()
	player_turn = 2 if galant else 1
	
	change_color()
	morp = []
	var compteur = 0
	for i in range (0,3):
		for j in range(0,3):
			var minimorp : Minimorpion = minimorp_temp.instantiate()
			#minimorp.get_child(1).num = compteur
			minimorp.num = compteur
			minimorp.nbHuman = nbHumanPlayer
			#morp[i].append(minimorp.get_child(1))
			morp.append(minimorp)
			big_morpion.add_child(minimorp)
			minimorp.initialiser_logos(logos)
			morp[3*i + j].minimorpion_played.connect(_on_mini_morpion_minimorpion_played)
			compteur +=1
	# morp[0].minimorp[0].grab_focus()
	case = morp[0].minimorp[0].case
	current_player_rect.set_texture(case[player_turn])
	let_all_choices()
	print(galant)
	if (galant && (nbHumanPlayer == 1)):
		print("ordi")
		computer_thinking()

func game_finished(num_winner):
	hud.set_state("gameover")
	#hud.game_over()
	hud.animation_fin()
	var timerFin = Timer.new()
	add_child(timerFin)
	timerFin.start(1)
	await timerFin.timeout
	timerFin.queue_free()
	#resultat_morpion.add_child($BigMorpion)
	#big_morpion.show()
	#big_morpion.position += Vector2(1000,200)
	#big_morpion.scale = big_morpion.scale * 0.4
	for ch in big_morpion.get_children() :
		big_morpion.remove_child(ch)
		resultat_morpion.add_child(ch)
		
	resultat_morpion.show()
	var nom_winner = ""
	if num_winner > 0:
		nom_winner = noms[num_winner-1]
	hud.end_of_game(nom_winner)
	

func let_all_choices():
	for m in morp:
		if m.win == 3:
			m.start_turn(player_turn)
			#push_warning(str(m.num) + " : pos all choices")
			morpdispo.append(m)

func let_none_choices():
	for m in morp:
		m.finish_turn()
		
func change_player():
	player_turn = 1 + player_turn%2
	current_player_rect.set_texture(case[player_turn])

func computer_play():
	var liste = []
	for minim in morpdispo:
		#push_warning(str(mini.num))
		liste.append(minim.cdispo)
	var _choice = $Computer.play(player_turn,morp, liste,morpdispo)

func computer_thinking():
	if (nbHumanPlayer == 1 && player_turn == ia_turn):
		var think_timer = Timer.new()
		add_child(think_timer)
		hud.reflexion_show(true)
		think_timer.start(2)
		await think_timer.timeout
		think_timer.queue_free()
		#hud.reflexion_show(false)
		computer_play()
	

func _on_mini_morpion_minimorpion_played(played,position):
	var morp_played = morp[played]
	morpdispo = []
	morp_played.check_winner()
	#push_warning(played)
	#if (morp_played.win != 3):
	#	push_warning('wiiiin')
	change_player()
	
	change_color()
	let_none_choices()
	if (morp[position].win!=3) :
		let_all_choices()
	else :
		morpdispo.append(morp[position])
		morp[position].start_turn(player_turn)
	
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
	for ch in big_morpion.get_children():
		big_morpion.remove_child(ch)

func _on_hud_return_menu():
	clear_game()

func _on_hud_change_state():
	if hud:
		if hud.state != "game":
			push_warning("activate every one")
			activate(-1, true)
		else :
			push_warning("activate first player:"+str(player_turn-1) + " no " +str(player_turn%2))
			# activate(player_turn-1,true)
			activate(-1,false)
			activate(player_turn-1,true)
