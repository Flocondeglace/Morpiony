class_name Case
extends Button

signal has_play

var case_empty = preload("res://Image/case_empty.png")
var case_p1
var case_p2
var case_egal = preload("res://Image/case_empty.png")
@onready var audio_stream_player_1: AudioStreamPlayer = $AudioStreamPlayer1
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2

var case = [case_empty,case_p1,case_p2,case_egal]

var pos
var win

func _ready():
	win = 0
	set_button_icon(case[0])
	
func initialiser_minimorpion(logos):
	case[1] = load(logos[0])
	case[2] = load(logos[1])
	#print("initialisation case")
	
func play_anim(num:int):
	if num == 1:
		audio_stream_player_1.play()
	else :
		audio_stream_player_2.play()
	var tween : Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "modulate:a",0.0, 0.01)
	tween.tween_property(self, "modulate:a",1.0, 0.5)
	

func set_piece(numPlayer:int):
	play_anim(numPlayer)
	# print(case[numPlayer])
	if (!is_disabled()) :
		set_button_icon(case[numPlayer])
		win = numPlayer
		has_play.emit(pos)
		set_disabled(true)
		
		#push_warning("pos :" + str(pos))
	else :
		push_warning("questufou" + str(pos))

func _on_pressed():
	var player = get_parent().current_player
	
	var nbHuman = get_parent().nbHuman
	if (nbHuman == 2 || player == 1):
		set_piece(get_parent().current_player)
