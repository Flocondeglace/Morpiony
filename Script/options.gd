extends CanvasLayer
signal difficulty_selected(diff:int)

@onready var option_button_language: OptionButton = %OptionButtonLanguage

func _ready() -> void:
	var local_language : String = OS.get_locale_language()
	var idx_lang : int = 0
	if local_language == "fr":
		idx_lang = 1
	option_button_language.select(idx_lang)
	_on_language_selected(idx_lang)

func _on_language_selected(index: int) -> void:
	var language : String = ""
	match index:
		0:
			language = "en"
		1: 
			language = "fr"
	TranslationServer.set_locale(language)


func _on_difficulty_selected(index: int) -> void:
	difficulty_selected.emit(index)


func _on_back_button_pressed() -> void:
	hide()
