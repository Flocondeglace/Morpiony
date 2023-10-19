extends Node

var minimorp_temp = preload("res://Scene/mini_morpion.tscn") 
var humanPlayer
var player_turn = 1
var morp = []
var morpdispo = []
var couleur = [Color(Color.CADET_BLUE),Color(Color.ROSY_BROWN)]


func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("escape"):
		get_tree().quit()

func new_game(nbPlayer):
	clear_game()
	morp = []
	humanPlayer = nbPlayer
	player_turn = 1
	var compteur = 0
	for i in range (0,3):
		for j in range(0,3):
			var minimorp = minimorp_temp.instantiate()
			#minimorp.get_child(1).num = compteur
			minimorp.num = compteur
			minimorp.nbHuman = humanPlayer
			#morp[i].append(minimorp.get_child(1))
			morp.append(minimorp)
			$BigMorpion.add_child(minimorp)
			morp[3*i + j].minimorpion_played.connect(_on_mini_morpion_minimorpion_played)
			compteur +=1
	let_all_choices()

func game_finished(num_winner):
	for ch in $BigMorpion.get_children() :
		$BigMorpion.remove_child(ch)
	$HUD.end_of_game(num_winner)
	

func let_all_choices():
	for m in morp:
		if m.win == 3:
			m.start_turn(player_turn)

func let_none_choices():
	for m in morp:
		m.finish_turn()
		
func change_player():
	player_turn = 1 + player_turn%2

func computer_play():
	var liste = []
	for mini in morpdispo:
		liste.append(mini.cdispo)
	var choice = $Computer.play(player_turn,morp,liste,morpdispo)

func computer_thinking():
	if (humanPlayer == 1 && player_turn == 2):
		var think_timer = Timer.new()
		add_child(think_timer)
		think_timer.start(0.5)
		await think_timer.timeout
		think_timer.queue_free()
		computer_play()
	

func _on_mini_morpion_minimorpion_played(played,pos):
	var morp_played = morp[played]
	morpdispo = []
	morp_played.check_winner()
	push_warning(played)
	if (morp_played.win != 3):
		push_warning('wiiiin')
	change_player()
	
	change_color()
	let_none_choices()
	if (morp[pos].win!=3) :
		let_all_choices()
		morpdispo = morp
	else :
		morpdispo.append(morp[pos])
		morp[pos].start_turn(player_turn)
	if (check_egalite_big()):
		game_finished(0)
	elif (check_winner_big(1)):
		game_finished(1)
	elif (check_winner_big(2)):
		game_finished(2)
	else:
		computer_thinking()
		#computer_play()

func change_color():
	$ColorRect.color = couleur[player_turn - 1]

func check_egalite_big():
	var complet = 0
	for m in morp:
		if (m.win != 3):
			complet +=1
	if complet == 9 :
		return true
	return false
	
func check_winner_big(player):
	var ligne
	var colonne
	for i in range(0,3):
		ligne = 0
		colonne = 0
		for j in range(0,3):
			if (morp[i*3 + j].win == player):
				ligne +=1
			if (morp[j*3 + i].win == player):
				colonne +=1
		if (ligne == 3 || colonne == 3):
			return true
	var diag1 = 0
	var diag2 = 0
	for i in range (0,3):
		if (morp[i*3 + i].win == player):
			diag1 += 1
			
		if (morp[i*3 + 2-i].win == player):
			diag2 += 1

	if (diag1 == 3 || diag2 == 3):
		return true
	return false

func clear_game():
	for ch in $BigMorpion.get_children():
		$BigMorpion.remove_child(ch)

func _on_hud_return_menu():
	clear_game()
