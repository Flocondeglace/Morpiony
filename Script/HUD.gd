extends CanvasLayer
# pour l'export
var borne: bool = true

# Signaux
signal start_game
signal return_menu
signal change_state

# Animation
@onready var anim_fin: AnimationPlayer = $"../AnimFin"
@onready var reflexion: CanvasLayer = $"../Reflexion"
@onready var points: Label = $"../Reflexion/Points"


# Block (panel)
@onready var choix_pions: PanelContainer = %ChoixPions
@onready var win_layer: CanvasLayer = $WinLayer
@onready var pause: Panel = $Pause
@onready var button_in_game_computer: Node = $ButtonInGameComputer
@onready var button_in_game_borne: Control = $ButtonInGameBorne
@onready var current_player: TextureRect = $CurrentPlayer
@onready var resultat_morpion: GridContainer = $ResultatMorpion
@onready var start_menu_button: GridContainer = $StartMenuButton
@onready var rules_panel: PanelContainer = $RulesPanel

# Block qui servent pas encore
@onready var options_ui: CanvasLayer = $OptionsUI

# Variable
var nbPlayer
## state : "menu" "choixpions" "game" "pause" "gameover"
var state
var selected

# Les boutons (notamment pour les grabs focus)
@onready var rules_button_debut: Button = $StartMenuButton/Rules
@onready var menu_button_win: Button = $StartMenuButton/Menu
@onready var start_button: Button = $StartMenuButton/StartButton
@onready var player1: Button = $StartMenuButton/GridContainer/Player1
@onready var player2: Button = $StartMenuButton/GridContainer/Player2

@onready var rules_button_pause: Button = $Pause/PauseButton/Rules
@onready var continuer_button: Button = $Pause/PauseButton/Continue

@onready var rules_quit_button: Button = $RulesPanel/Container/RulesQuitButton


var big

func _ready():
	big = get_parent().get_parent().get_parent().get_node("CenterContainer/BigMorpion")
	tout_cacher()
	act_menu_start()
	set_state("menu")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1Joueur"):
		if state=="menu":
			player1.set_pressed(true)
		else:
			_on_menu_pressed()
	if event.is_action_pressed("2Joueur"):
		if state=="menu":
			player2.set_pressed(true)
		else:
			_on_menu_pressed()
	
	if event.is_action_pressed("retour_menu") && state == "game":
		_on_menu_pressed()
		
	if event.is_action_pressed("pause") && state == "game":
		selected = big.get_viewport().gui_get_focus_owner()
		$CurrentPlayer.hide()
		pause_menu_show()
	else :
		if event.is_action_pressed("pause") && state == "pause":
			pause_menu_hide()
			$CurrentPlayer.show()
			selected.grab_focus()



func tout_cacher():
	pause.hide()
	win_layer.hide()
	button_in_game_computer.hide()
	button_in_game_borne.hide()
	current_player.hide()
	options_ui.hide()
	resultat_morpion.hide()
	choix_pions.hide()
	choix_pions.reset()
	start_menu_button.hide()

func desact_button_game():
	button_in_game_computer.hide()
	button_in_game_borne.hide()
	current_player.hide()
	
func act_button_game():
	if borne:
		button_in_game_borne.show()
	else:
		button_in_game_computer.show()
	current_player.show()

func desact_menu_start():
	$StartMenuButton.hide()
	$TitleLabel.hide()
	$WinLayer.hide()
	menu_button_win.hide()
	
func act_menu_start():
	tout_cacher()
	menu_button_win.hide()
	start_button.text = 'Jouer'
	start_menu_button.show()
	start_button.grab_focus()
	$TitleLabel.show()

func desact_menu_pause():
	pause.hide()

func _on_start_button_pressed():
	init_gridContainer(resultat_morpion)
	resultat_morpion.hide()
	set_state("game")
	desact_menu_pause()
	desact_menu_start()
	act_button_game()
	if (player1.button_pressed):
		nbPlayer = 1
		start_game.emit(1)
	else :
		nbPlayer = 2
		start_game.emit(2)

func end_of_game(nom_winner):
	set_state("gameover")
	button_in_game_computer.hide()
	button_in_game_borne.hide()
	current_player.hide()
	start_button.text = "Rejouer"
	start_menu_button.show()
	start_button.grab_focus()
	if (nom_winner != ""):
		$WinLayer/WinnerLabel.text = nom_winner + " a gagné :)"
	else :
		$WinLayer/WinnerLabel.text = "Egalité : Aucun gagnant aucun perdant \n tout le monde est content ?!"
	win_layer.show()
	menu_button_win.show()
	resultat_morpion.show()
	
#vide de ses enfants un grid container
func init_gridContainer(grid):
	for ch in grid.get_children():
		grid.remove_child(ch)
		
func animation_fin():
	anim_fin.play("transition_fin_partie")

func _on_restart_pressed():
	_on_start_button_pressed()

func _on_menu_pressed():
	tout_cacher()
	init_gridContainer(resultat_morpion)
	set_state("menu")
	return_menu.emit()
	act_menu_start()

func pause_menu_show():
	set_state("pause")
	pause.show()
	continuer_button.grab_focus()

func pause_menu_hide():
	set_state("game")
	pause.hide()
	
func set_state(s):
	state = s
	change_state.emit()
	
func reflexion_show(b):
	
	reflexion.show()
	for i in range(0,2):
		points.text = "."
		await get_tree().create_timer(0.3).timeout
		points.text = ".."
		await get_tree().create_timer(0.3).timeout
		points.text = "..."
		await get_tree().create_timer(0.3).timeout
	reflexion.hide()

	

func _on_continue_pressed():
	current_player.show()
	selected.grab_focus()
	pause_menu_hide()


func _on_rules_pressed():
	rules_panel.show()
	rules_quit_button.grab_focus()


func _on_rules_quit_button_pressed():
	rules_panel.hide()
	if state == "pause":
		rules_button_pause.grab_focus()
	else :
		rules_button_debut.grab_focus()
		
