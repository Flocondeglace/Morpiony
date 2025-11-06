extends ClickButton

const MUSIC_OFF = preload("uid://dh14ah38msggf")
const MUSIC_ON = preload("uid://dgatcuv56svk4")

func _on_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)
	if toggled_on:
		icon = MUSIC_OFF
	else:
		icon = MUSIC_ON
