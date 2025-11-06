class_name MenuMorpion
extends Control

# Background
@onready var background: TextureRect = $Background
@export var player_back_color: Array[Color]

@export var time_anim_big_morpion : float = 0.3

# Audio
@onready var win_audio_stream_player: AudioStreamPlayer = $Popups/Game/WinAudioStreamPlayer
@onready var loose_audio_stream_player: AudioStreamPlayer = $Popups/Game/LooseAudioStreamPlayer

# UI
@onready var options: CanvasLayer = $Popups/Options
@onready var rules: CanvasLayer = $Popups/Rules
@onready var reflexion: CanvasLayer = $Popups/Reflexion
@onready var menu: CanvasLayer = $Popups/Menu
@onready var game: CanvasLayer = $Popups/Game
@onready var pawn_selection: CanvasLayer = $Popups/PawnSelection
@onready var end_game: EndGame = $Popups/EndGame
@onready var pause: CanvasLayer = $Popups/Pause

# Game
const MINI_MORPION = preload("uid://b4e5urc4pptpp")
const EXPLOSION_PARTICULES = preload("uid://b1nb4avkki6k0")

# Config
var galant : bool
var ia_turn : int = 2
var nbHumanPlayer : int = 1
var computer_strat : int = 2

var pawn_names = []
var logos = []
@onready var big_morpion: GridContainer = $Popups/Game/CenterContainer/BigMorpion

# In Game
var computer : Computer
@onready var current_player: TextureRect = $Popups/Game/CurrentPlayer
var player_turn :int = 1
var morp : Array[Minimorpion] = []
var morpdispo = []
var in_game:bool = false

# End Game
@onready var result_morpion: GridContainer = $Popups/EndGame/CenterContainer/ResultMorpion

func _ready() -> void:
	mask_popups()
	menu.show()
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("escape"):
		get_tree().quit()

func mask_popups():
	menu.hide()
	options.hide()
	rules.hide()
	reflexion.hide()
	game.hide()
	pawn_selection.hide()
	end_game.hide()
	pause.hide()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	options.show()

func _on_rules_pressed() -> void:
	rules.show()

func _on_play_pressed() -> void:
	mask_popups()
	new_game()

# position du morpion dans lequel le joueur doit jouer
var pos
var case


func select_pawn():
	pawn_names = []
	galant = false
	pawn_selection.show();
	for i in range(nbHumanPlayer):
		pawn_selection.changer_couleur(player_back_color[i])
			
		pawn_selection.changer_texte(tr("PLAYER") + " " + str(i + 1),i==0)
			
		var pawn_name = await pawn_selection.joueurChoisi
		if i==0:
			galant = await pawn_selection.galant
		pawn_names.append(pawn_name)
	if nbHumanPlayer == 1 :
		pawn_names.append("Godot")
	export_to_logos()
	print("fin choix " + str(galant))
	pawn_selection.hide()
	pawn_selection.reset()
	in_game = true

func export_to_logos():
	logos = []
	for n in pawn_names:
		logos.append("res://Image/Pions/"+n.to_lower()+".png")

func new_game():
	print("newgame")
	
	# Set Up Computer
	if nbHumanPlayer == 1:
		if computer:
			computer.reset()
		else:
			computer = Computer.new()
		computer.change_strat(computer_strat)
	
	in_game = true
	await select_pawn()
	game.show()
	print("first :" + str(galant))
	clear_game()
	player_turn = 2 if galant else 1
	
	change_color()
	morp = []
	var compteur = 0
	for i in range (0,3):
		for j in range(0,3):
			var minimorp : Minimorpion = MINI_MORPION.instantiate()
			#minimorp.get_child(1).num = compteur
			minimorp.num = compteur
			minimorp.nbHuman = nbHumanPlayer
			#morp[i].append(minimorp.get_child(1))
			morp.append(minimorp)
			big_morpion.add_child(minimorp)
			minimorp.initialiser_logos(logos)
			morp[3*i + j].minimorpion_played.connect(_on_mini_morpion_minimorpion_played)
			compteur +=1
	
	case = morp[0].minimorp[0].case
	current_player.set_texture(case[player_turn])
	let_all_choices()
	print(galant)
	if (galant && (nbHumanPlayer == 1)):
		print("ordi")
		computer_thinking()

func game_finished(num_winner):
	if nbHumanPlayer < 2 && num_winner == ia_turn:
		loose_audio_stream_player.play()
	else:
		win_audio_stream_player.play()
	# empty the previous results
	for ch in result_morpion.get_children():
		result_morpion.remove_child(ch)
	for ch : Minimorpion in big_morpion.get_children() :
		big_morpion.remove_child(ch)
		result_morpion.add_child(ch)
		ch.set_case_accessible(false)
	result_morpion.show()
	var winner_name = ""
	if num_winner > 0:
		winner_name = pawn_names[num_winner-1]
	end_game.end(winner_name)
	game.hide()
	

func let_all_choices():
	for m in morp:
		if m.win == 3:
			m.start_turn(player_turn)
			morpdispo.append(m)

func let_none_choices():
	for m in morp:
		m.finish_turn()
		
func change_player():
	player_turn = 1 + player_turn%2
	current_player.set_texture(case[player_turn])

func computer_choose():
	var liste = []
	for minim in morpdispo:
		liste.append(minim.cdispo)
	var _choice = computer.choose(player_turn,morp, liste,morpdispo)

func computer_play():
	computer.play()

func computer_thinking():
	if (nbHumanPlayer == 1 && player_turn == ia_turn):
		computer_choose()
		var think_timer = Timer.new()
		add_child(think_timer)
		reflexion.think()


func _on_mini_morpion_minimorpion_played(played:int, position_played:int) -> void:
	var morp_played = morp[played]
	morpdispo = []
	morp_played.check_winner()
	change_player()
	
	change_color()
	let_none_choices()
	if (morp[position_played].win!=3) :
		let_all_choices()
	else :
		morpdispo.append(morp[position_played])
		morp[position_played].start_turn(player_turn)
	var check_player1_win :int = check_winner_big(1)
	var check_player2_win :int = check_winner_big(2)
	if (check_player1_win!=-1):
		push_warning("player 1 win")
		game_finished(1)
		anim_win(check_player1_win)
	elif (check_player2_win!=-1):
		push_warning("player 2 win")
		game_finished(2)
		anim_win(check_player2_win)
	elif (check_egalite_big()):
		push_warning("egaliteeeeeeeeeeeeeeeeee")
		game_finished(0)
	else:
		computer_thinking()

func change_color():
	background.modulate = player_back_color[player_turn - 1]

func check_egalite_big():
	var complet = 0
	for m in morp:
		if (m.win != 3):
			complet +=1
	if complet == 9 :
		return true
	return false

func anim_win(num:int):
	
	var to_anim : Array[Minimorpion] = []
	if num < 3:
		for i in range(3):
			to_anim.append(result_morpion.get_child(num*3+i))
	elif num < 6:
		for i in range(3):
			to_anim.append(result_morpion.get_child(i*3+num-3))
	else :
		match num:
			6:
				for i in range(3):
					to_anim.append(result_morpion.get_child(i*3+i))
			7:
				for i in range(3):
					to_anim.append(result_morpion.get_child(2+2*i))
	for m : Minimorpion in to_anim:
		var part : CPUParticles2D = EXPLOSION_PARTICULES.instantiate()
		m.add_child(part)
		part.position = Vector2(200,200)
		part.emitting = true
		await get_tree().create_timer(time_anim_big_morpion).timeout

func check_winner_big(player) -> int:
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
		if ligne == 3 :
			return i
		if colonne == 3 :
			return i + 3
	var diag1 = 0
	var diag2 = 0
	for i in range (0,3):
		if (morp[i*3 + i].win == player):
			diag1 += 1
			
		if (morp[i*3 + 2-i].win == player):
			diag2 += 1

	if diag1 == 3:
		return 6
	if diag2 == 3:
		return 7
	return -1

func clear_game():
	for ch in big_morpion.get_children():
		big_morpion.remove_child(ch)

func _on_solo_pressed() -> void:
	nbHumanPlayer = 1

func _on_versus_pressed() -> void:
	nbHumanPlayer = 2
	
func _on_menu_pressed() -> void :
	background.modulate = Color.WHITE
	clear_game()
	mask_popups()
	menu.show()

func _on_reflexion_finished() -> void:
	computer_play()

func _on_pause_pressed() -> void:
	pause.show()
