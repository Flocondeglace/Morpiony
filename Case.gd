extends Button

signal has_play

var case_empty = preload("res://Image/case_empty.png")
var case_p1 = preload("res://Image/case_circle.png")
var case_p2 = preload("res://Image/case_cross.png")

var case = [case_empty,case_p1,case_p2]

var pos
var win


# Called when the node enters the scene tree for the first time.
func _ready():
	win = 0
	set_button_icon(case[0])

func set_piece(numPlayer,pos):
	set_button_icon(case[numPlayer])
	win = numPlayer
	has_play.emit(pos)
	set_disabled(true)

func _on_pressed():
	#set_piece(get_parent().get_parent().get_parent().get_parent().player_turn)
	
	set_piece(get_parent().current_player,pos)
