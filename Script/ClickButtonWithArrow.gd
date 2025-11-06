class_name ClickButtonWithArrow
extends ClickButton

@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	super._ready()
	texture_rect.visible = button_pressed
	
func _toggled(toggled_on: bool) -> void:
	texture_rect.visible = toggled_on
