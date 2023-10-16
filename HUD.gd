extends CanvasLayer

signal start_game

func _ready():
	$WinnerLabel.hide()

func _on_start_button_pressed():
	$StartButton.hide()
	$TitleLabel.hide()
	$WinnerLabel.hide()
	start_game.emit()

func end_of_game(num_player):
	$StartButton.text = "Restart"
	$StartButton.show()
	$WinnerLabel.text = "player " + str(num_player) + " won"
	$WinnerLabel.show()
	
