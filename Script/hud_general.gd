extends CanvasLayer

signal start
signal menu
signal change_state
signal computer_strat_selected(st:int)

func _on_hud_canva_start_game(nbplayer):
	start.emit(nbplayer)

func _on_hud_canva_return_menu():
	menu.emit()

func _on_hud_change_state():
	change_state.emit()

func _on_hud_canva_continue_game():
	get_parent().select_button()


func _on_quitter_pressed() -> void:
	get_tree().quit()


func _on_computer_strat_selected(st: int) -> void:
	computer_strat_selected.emit(st)


func _on_sound_button_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)
