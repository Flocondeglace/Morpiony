class_name EndGame
extends CanvasLayer

@onready var label: Label = $Label

func end(winner_name):
	if (winner_name != ""):
		label.text = winner_name +" "+ tr("WIN_TEXT")
	else :
		label.text = tr("TIE_TEXT")
	show()
