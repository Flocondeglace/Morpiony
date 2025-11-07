class_name AvatarButtons
extends GridContainer

signal avatar_selected(id:int, avatar:String)

@export var default_avatar : Button
@export var group : ButtonGroup
@export var id_player : int

func _ready() -> void:
	default_avatar.button_pressed = true
	for c in get_children():
		if c is Button:
			c.button_group = group
	group.pressed.connect(_on_avatar_selected)

func reset():
	for avatar in group.get_buttons():
		avatar.disabled = false

func _on_avatar_selected(b:Button):
	avatar_selected.emit(id_player, b.get_name())

func disable_avatar(avatar_name : String)->void:
	for b : Button in group.get_buttons():
		b.disabled = (b.get_name() == avatar_name)

func get_current_avatar() -> String:
	return group.get_pressed_button().get_name()
