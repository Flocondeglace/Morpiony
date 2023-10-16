extends GridContainer

signal minimorpion_played

var minimorp = []
var win
var case_temp = preload("res://Scene/case.tscn")
var num
var current_player

# Called when the node enters the scene tree for the first time.
func _ready():
	win = 0
	#remove_child($Case)
	for i in range (0,3):
		#minimorp.append([])
		for j in range(0,3):
			var case = case_temp.instantiate()
			#case.scale = Vector2(0.1,0.1)
			#minimorp[i].append(case)
			minimorp.append(case)
			case.pos = j + i*3
			add_child(case)
			case.has_play.connect(_on_case_has_play)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_turn(player_turn):
	set_case_accessible(true)
	current_player = player_turn

func finish_turn():
	set_case_accessible(false)

## boolean b : true si on veut les cases accessibles, false sinon
func set_case_accessible(b):
	for case in minimorp:
		if case.win == 0 :
			case.set_disabled(!b)

func finish():
	var icon_winner = get_child(0).case[win]
	for ch in get_children():
		remove_child(ch)
	var big_case = TextureRect.new()
	push_warning(win)
	big_case.set_texture(icon_winner)
	#big_case.set_scale(Vector2(3,3))
	
	#big_case.size_flags_horizontal = Control.SIZE_FILL
	#big_case.stretch_mode=1
	add_child(big_case)
	#get_child(0).set_size(Vector2(get_parent().get_size()))
	get_child(0).size_flags_horizontal = Control.SIZE_EXPAND_FILL
	get_child(0).size_flags_vertical = Control.SIZE_EXPAND_FILL
	#get_child(0).size_flags_stretch_ratio = 100
	#fit_child_in_rect(get_child(0),get_rect())
	
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
	push_warning("nb dans diag: " + str(diag1))
	return false


func _on_case_has_play(pos):
	minimorpion_played.emit(num,pos)
