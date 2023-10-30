extends CanvasLayer

signal start_game
signal return_menu

var nbPlayer
var player1
var player2
var start_button
var menu_button_win
## state : "menu" "game" "pause" "gameover"
var state
var big
var selected


func _ready():
	big = get_parent().get_parent().get_parent().get_node("BigMorpion")
	player1 = get_node("StartMenuButton/GridContainer/Player1")
	player2 = get_node("StartMenuButton/GridContainer/Player2")
	start_button = get_node("StartMenuButton/StartButton")
	menu_button_win = get_node("StartMenuButton/Menu")
	
	$WinLayer.hide()
	$Restart.hide()
	$Menu.hide()
	$OptionsUI.hide()
	$Pause.hide()
	$CurrentPlayer.hide()
	$ResultatMorpion.hide()
	menu_button_win.hide()
	act_menu_start()
	state = "menu"
	#player1.set_shortcut(Input.is_action_pressed("1Joueur"))

func _process(delta):
	if Input.is_action_pressed("1Joueur"):
		player1.set_pressed(true)
	if Input.is_action_pressed("2Joueur"):
		player2.set_pressed(true)
	
	if Input.is_action_just_pressed("pause") && state == "game":
		selected = big.get_viewport().gui_get_focus_owner()
		$CurrentPlayer.hide()
		pause_menu_show()
	else :
		if Input.is_action_just_pressed("pause") && state == "pause":
			pause_menu_hide()
			$CurrentPlayer.show()
			selected.grab_focus()
	
		
func desact_button_game():
	$Menu.hide()
	$Restart.hide()
	$CurrentPlayer.hide()

func desact_menu_start():
	$StartMenuButton.hide()
	$TitleLabel.hide()
	$WinLayer.hide()
	menu_button_win.hide()
	
func act_menu_start():
	$CurrentPlayer.hide()
	$ResultatMorpion.hide()
	start_button.text = 'Start'
	$StartMenuButton.show()
	start_button.grab_focus()
	$TitleLabel.show()

func _on_start_button_pressed():
	init_gridContainer($ResultatMorpion)
	$ResultatMorpion.hide()
	state = "game"
	desact_menu_start()
	$Restart.show()
	$Menu.show()
	$CurrentPlayer.show()
	if (player1.button_pressed):
		nbPlayer = 1
		start_game.emit(1)
	else :
		nbPlayer = 2
		start_game.emit(2)

#func game_over():
#	 state = "gameover"

func end_of_game(num_player):
	state = "gameover"
	desact_button_game()
	start_button.text = "Restart"
	$StartMenuButton.show()
	start_button.grab_focus()
	if (num_player != 0):
		$WinLayer/WinnerLabel.text = "Player " + str(num_player%2 + 1) + " loose :)"
	else :
		$WinLayer/WinnerLabel.text = "equalityyyyyyyyyyyyyyy you are all noob"
	$WinLayer.show()
	menu_button_win.show()
	$ResultatMorpion.show()
	
#vide de ses enfants un grid container
func init_gridContainer(grid):
	for ch in grid.get_children():
		grid.remove_child(ch)

func _on_restart_pressed():
	init_gridContainer($ResultatMorpion)
	$ResultatMorpion.hide()
	$CurrentPlayer.show()
	$WinLayer.hide()
	desact_menu_start()
	pause_menu_hide()
	start_game.emit(nbPlayer)

func _on_menu_pressed():
	init_gridContainer($ResultatMorpion)
	$ResultatMorpion.hide()
	state = "menu"
	return_menu.emit()
	$WinLayer.hide()
	$Restart.hide()
	$Menu.hide()
	$Pause.hide()
	menu_button_win.hide()
	act_menu_start()

func pause_menu_show():
	state = "pause"
	$Pause.show()
	$Pause/Continue.grab_focus()

func pause_menu_hide():
	state = "game"
	$Pause.hide()

func _on_continue_pressed():
	$CurrentPlayer.show()
	selected.grab_focus()
	pause_menu_hide()
