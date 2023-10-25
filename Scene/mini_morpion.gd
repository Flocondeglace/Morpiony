extends GridContainer

signal minimorpion_played

var minimorp = []
var cdispo = []
var win
var case_temp = preload("res://Scene/case.tscn")

#light
var texture_light = preload("res://Image/2d_lights_and_shadows_neutral_point_light.webp")
var light

var num
var current_player
var nbHuman
var beffect = false

# Called when the node enters the scene tree for the first time.
func _ready():
	win = 3
	for i in range (0,3):
		for j in range(0,3):
			var case = case_temp.instantiate()
			minimorp.append(case)
			case.pos = j + i*3
			add_child(case)
			case.has_play.connect(_on_case_has_play)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if beffect :
		var en = light.get_energy()
		if (en >= 0.01):
			light.set_energy(en - 0.05)

func start_turn(player_turn):
	current_player = player_turn
	set_case_accessible(true)
	cdispo[0].grab_focus()

func finish_turn():
	set_case_accessible(false)

## boolean b : true si on veut les cases accessibles, false sinon
func set_case_accessible(b):
	cdispo = minimorp.filter(func(case): return case.win == 0)
	for case in cdispo :
		case.set_disabled(!b)
	#for case in minimorp:
	#	if case.win == 0 :
	#		cdispo.append(case)
	#		case.set_disabled(!b)

func finish():
	var icon_winner = minimorp[0].case[win%3]
	for ch in get_children():
		remove_child(ch)
	
	var big_case = TextureRect.new()
	push_warning(win)
	big_case.set_texture(icon_winner)
	columns = 1
	add_child(big_case)
	get_child(0).size_flags_horizontal = Control.SIZE_EXPAND_FILL
	get_child(0).size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	effect_finish()

func effect_finish():
	var lightTimer = Timer.new()
	beffect = true
	add_child(lightTimer)
	lightTimer.start()
	light = PointLight2D.new()
	light.set_texture(texture_light)
	light.set_texture_offset(Vector2(size)/2)
	light.set_texture_scale(2)
	add_child(light)
	await lightTimer.timeout
	beffect = false
	lightTimer.queue_free()
	light.queue_free()
	
	

	
func check_winner():
	for i in range (1,3):
		if (check_winner_p(i)):
			win = i
			finish()
	if (check_egalite()):
		win = 0
		finish()

func check_egalite():
	var complet = 0
	for i in range(0,3):
		for j in range(0,3):
			if (minimorp[j + 3*i].win != 0):
				complet +=1
	if complet == 9 :
		return true
	return false
	
func check_winner_p(player):
	var ligne
	var colonne
	for i in range(0,3):
		ligne = 0
		colonne = 0
		for j in range(0,3):
			if (minimorp[i*3 + j].win == player):
				ligne +=1
			if (minimorp[j*3 + i].win == player):
				colonne +=1
		if (ligne == 3 || colonne == 3):
			return true
	var diag1 = 0
	var diag2 = 0
	for i in range (0,3):
		if (minimorp[i*3 + i].win == player):
			diag1 += 1
			
		if (minimorp[i*3 + 2-i].win == player):
			diag2 += 1

	if (diag1 == 3 || diag2 == 3):
		return true
	return false


func _on_case_has_play(pos):
	minimorpion_played.emit(num,pos)
