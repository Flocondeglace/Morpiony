extends CanvasLayer

signal start_game
signal return_menu
var nbPlayer
var player1
var player2
var start_button

func _ready():
	player1 = get_node("StartMenuButton/GridContainer/Player1")
	player2 = get_node("StartMenuButton/GridContainer/Player2")
	start_button = get_node("StartMenuButton/StartButton")
	$WinLayer.hide()
	$Restart.hide()
	$Menu.hide()
	$OptionsUI.hide()

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
	$TitleLabel.show()

func _on_start_button_pressed():
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
	desact_button_game()
	start_button.text = "Restart"
	$StartMenuButton.show()
	if (num_player != 3):
		$WinLayer/WinnerLabel.text = "Player " + str(num_player%2 + 1) + " loose :)"
	else :
		$WinLayer/WinnerLabel.text = "equalityyyyyyyyyyyyyyy you are all noob"
	$WinLayer.show()


func _on_restart_pressed():
	$WinLayer.hide()
	desact_menu_start()
	start_game.emit(nbPlayer)

func _on_menu_pressed():
	return_menu.emit()
	$WinLayer.hide()
	$Restart.hide()
	$Menu.hide()
	act_menu_start()


