class_name avatar_button
extends Button

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	pressed.connect(_on_select)
	
func _on_select():
	audio_stream_player.play()
