class_name ClickButton
extends Button

@onready var select_audio_stream_player: AudioStreamPlayer = %SelectAudioStreamPlayer

func _ready() -> void:
	pressed.connect(_on_select)
	
func _on_select():
	select_audio_stream_player.play()
