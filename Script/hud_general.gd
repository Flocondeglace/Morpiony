extends CanvasLayer

signal start
signal menu
signal change_state

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
	
