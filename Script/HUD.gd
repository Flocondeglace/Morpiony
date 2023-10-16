extends CanvasLayer

signal start_game

func _ready():
	$WinnerLabel.hide()

func _on_start_button_pressed():
	$StartButton.hide()
	$TitleLabel.hide()
	$WinnerLabel.hide()
	$Player1.hide()
	$Player2.hide()
	if ($Player1.button_pressed):
		start_game.emit(1)
	else :
		start_game.emit(0)

func end_of_game(num_player):
	$StartButton.text = "Restart"
	$StartButton.show()
	$Player1.show()
	$Player2.show()
	$WinnerLabel.text = "player " + str(num_player) + " won"
	$WinnerLabel.show()
	
