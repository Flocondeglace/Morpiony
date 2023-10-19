extends CanvasLayer

signal start_game
signal return_menu
var nbPlayer

func _ready():
	$WinLayer.hide()
	$Restart.hide()
	$Menu.hide()

func desact_button_game():
	$Menu.hide()
	$Restart.hide()

func desact_menu_start():
	$StartButton.hide()
	$TitleLabel.hide()
	$WinLayer.hide()
	$Player1.hide()
	$Player2.hide()
	
func act_menu_start():
	$StartButton.show()
	$StartButton.text = 'Start'
	$TitleLabel.show()
	$Player1.show()
	$Player2.show()

func _on_start_button_pressed():
	desact_menu_start()
	$Restart.show()
	$Menu.show()
	if ($Player1.button_pressed):
		nbPlayer = 1
		start_game.emit(1)
	else :
		nbPlayer = 2
		start_game.emit(2)

func end_of_game(num_player):
	desact_button_game()
	$StartButton.text = "Restart"
	$StartButton.show()
	$Player1.show()
	$Player2.show()
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


