extends CanvasLayer

signal start
signal menu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hud_canva_start_game(nbplayer):
	start.emit(nbplayer)

func _on_hud_canva_return_menu():
	menu.emit()
