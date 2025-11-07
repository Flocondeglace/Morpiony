class_name PawnSelection
extends CanvasLayer

signal pawn_selected(names : Array[String], galant: bool)
 
@export var player1_choices : AvatarButtons
@export var player2_choices : AvatarButtons
@export var computer_choices : AvatarButtons
@export var player2_ui : Control
@export var computer_ui : Control
@onready var play_first: ClickButton = %PlayFirst
@onready var valider_button: ClickButton = %ValiderButton

var avatar_choices : Array[AvatarButtons]

func show_pawn_selection(two_players : bool):
	player2_ui.visible = two_players
	computer_ui.visible = !two_players
	avatar_choices = [player1_choices]
	if two_players:
		avatar_choices.append(player2_choices)
	else:
		avatar_choices.append(computer_choices)
	show()

func _on_valider():
	var avatars : Array[String] = []
	for a : AvatarButtons in avatar_choices:
		avatars.append(a.get_current_avatar())
	pawn_selected.emit(avatars, !play_first.button_pressed)
	hide()

func _on_back():
	hide()


func _on_avatar_selected(id: int, avatar: String) -> void:
	avatar_choices[(id + 1)%2].disable_avatar(avatar)
