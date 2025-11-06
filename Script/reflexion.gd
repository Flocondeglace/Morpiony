extends CanvasLayer

signal reflexion_finished

@onready var reflexion_animation_player: AnimationPlayer = $ReflexionAnimationPlayer

func think() -> void:
	show()
	reflexion_animation_player.play("think")
	await reflexion_animation_player.animation_finished
	reflexion_animation_player.play("think")
	await reflexion_animation_player.animation_finished
	reflexion_finished.emit()
	hide()
