class_name ClickButtonWithArrow
extends ClickButton

const ARROW = preload("uid://c6dfqnwxehwkl")

var texture_rect: TextureRect

func _ready() -> void:
	super._ready()
	texture_rect = ARROW.instantiate()
	add_child(texture_rect)
	texture_rect.visible = button_pressed

func _draw() -> void:
	texture_rect.position = Vector2(size.x/2 - texture_rect.size.x/2, -texture_rect.size.y - 25)
	

func _toggled(toggled_on: bool) -> void:
	texture_rect.position = Vector2(size.x/2 - texture_rect.size.x/2, -texture_rect.size.y - 25)
	texture_rect.visible = toggled_on
