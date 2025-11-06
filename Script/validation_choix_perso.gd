extends CanvasLayer

signal joueurChoisi(nom)
signal galant

@onready var valider_button = $PanelContainer/Container/HBoxContainer/ValiderButton
@onready var _7_fault: Button = $"PanelContainer/Container/GridContainer/7Fault"
@onready var groupe =_7_fault.button_group
@onready var joueur = $PanelContainer/Container/Joueur
@onready var play_first: CheckButton = $PanelContainer/Container/HBoxContainer/PlayFirst


func changer_texte(texte,galbutton):
	_7_fault.button_pressed = true
	joueur.set_text(texte)
	if galbutton:
		play_first.show()
	else :
		play_first.hide()

func changer_couleur(couleur):
	joueur["theme_override_colors/font_color"] = couleur

func reset():
	for pion in groupe.get_buttons():
		# print("reset1")
		pion.disabled = false

func _on_valider():
	var bouton_presse = groupe.get_pressed_button()
	bouton_presse.disabled = true
	joueurChoisi.emit(bouton_presse.get_name())
	galant.emit(!play_first.button_pressed)
