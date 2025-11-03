extends Button

signal has_play

var case_empty = preload("res://Image/case_empty.png")
var case_p1 = preload("res://Image/ber7ker.png")
var case_p2 = preload("res://Image/pan7on.png")
var case_egal = preload("res://Image/case_empty.png")

# Halloween
#var case_empty = preload("res://Image/case_empty.png")
#var case_p1 = preload("res://Image/citrouille.png")
#var case_p2 = preload("res://Image/chauve_souris.png")
#var case_egal = preload("res://Image/mix_citrouille_chauve_souris.png")

var case = [case_empty,case_p1,case_p2,case_egal]

var pos
var win


# Called when the node enters the scene tree for the first time.
func _ready():
	win = 0
	set_button_icon(case[0])
	
func initialiser_minimorpion(logos):
	case[1] = load(logos[0])
	case[2] = load(logos[1])
	#print("initialisation case")
	

func set_piece(numPlayer):
	print(case[numPlayer])
	if (!is_disabled()) :
		set_button_icon(case[numPlayer])
		win = numPlayer
		has_play.emit(pos)
		set_disabled(true)
		
		#push_warning("pos :" + str(pos))
	else :
		push_warning("questufou" + str(pos))

func _on_pressed():
	#set_piece(get_parent().get_parent().get_parent().get_parent().player_turn)
	var player = get_parent().current_player
	var nbHuman = get_parent().nbHuman
	if (nbHuman == 2 || player == 1):
		set_piece(get_parent().current_player)
