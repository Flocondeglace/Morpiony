extends CanvasLayer

signal start_game
signal return_menu

var nbPlayer
var player1
var player2
var start_button
## state : "menu" "game" "pause" "gameover"
var state
var big
var selected


func _ready():
	big = get_parent().get_parent().get_parent().get_node("BigMorpion")
	player1 = get_node("StartMenuButton/GridContainer/Player1")
	player2 = get_node("StartMenuButton/GridContainer/Player2")
	start_button = get_node("StartMenuButton/StartButton")
	$WinLayer.hide()
	$Restart.hide()
	$Menu.hide()
	$OptionsUI.hide()
	$Pause.hide()
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
		pause_menu_show()
	else :
		if Input.is_action_just_pressed("pause") && state == "pause":
			pause_menu_hide()
			selected.grab_focus()
	
		
func desact_button_game():
	$Menu.hide()
	$Restart.hide()

func desact_menu_start():
	$StartMenuButton.hide()
	$TitleLabel.hide()
	$WinLayer.hide()
	
func act_menu_start():
	start_button.text = 'Start'
	$StartMenuButton.show()
	start_button.grab_focus()
	$TitleLabel.show()

func _on_start_button_pressed():
	state = "game"
	desact_menu_start()
	$Restart.show()
	$Menu.show()
	if (player1.button_pressed):
		nbPlayer = 1
		start_game.emit(1)
	else :
		nbPlayer = 2
		start_game.emit(2)

func end_of_game(num_player):
	state = "gameover"
	desact_button_game()
	start_button.text = "Restart"
	$StartMenuButton.show()
	start_button.grab_focus()
	if (num_player != 3):
		$WinLayer/WinnerLabel.text = "Player " + str(num_player%2 + 1) + " loose :)"
	else :
		$WinLayer/WinnerLabel.text = "equalityyyyyyyyyyyyyyy you are all noob"
	$WinLayer.show()


func _on_restart_pressed():
	$WinLayer.hide()
	desact_menu_start()
	pause_menu_hide()
	start_game.emit(nbPlayer)

func _on_menu_pressed():
	state = "menu"
	return_menu.emit()
	$WinLayer.hide()
	$Restart.hide()
	$Menu.hide()
	act_menu_start()

func pause_menu_show():
	state = "pause"
	$Pause.show()
	$Pause/Continue.grab_focus()

func pause_menu_hide():
	state = "game"
	$Pause.hide()

func _on_continue_pressed():
	pause_menu_hide()
