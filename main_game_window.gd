extends Control
var first_start = true
var player : Dictionary
var enemy : Dictionary
var turn = true
func _process(delta: float) -> void:
	if first_start == true:
		randize_ivs()
		$shadowed/Player/HPBar.max_value = player.hp
		$shadowed/Player/HPBar.value = player.hp
		summon_lvl_one()
		first_start = false
	if turn == false:
		$shadowed/Fight.disabled = true
	


func fight() -> void:
	$non_shadowed/moves_menu.show()
	$shadowed/shad.show()
	
func randize_ivs():
	if first_start == true:
		var hp = randi_range(20,31)
		var speed = randi_range(1,5)
		var def = randi_range(1,5)
		var atk = randi_range(1,5)
		player = {
			"hp" : hp,
			"speed" : speed,
			"def" : def,
			"atk" : atk,
		}
func summon_lvl_one():
	var hp = randi_range(5,10)
	var speed = randi_range(1,5)
	var def = randi_range(1,5)
	var atk = randi_range(1,5)
	var mov1 = randi_range(1,4)
	var mov2 = randi_range(1,4)
	var mov3 = randi_range(1,4)
	var mov4 = randi_range(1,4)
	enemy = {
		"class" : "very very easy",
		"hp" : hp,
		"speed" : speed,
		"def" : def,
		"atk" : atk,
		"mov1" : mov1,
		"mov2" : mov2,
		"mov3" : mov3,
		"mov4" : mov4
	}
	$shadowed/Enemy/Enemy_HP.max_value = enemy.hp
	$shadowed/Enemy/Enemy_HP.value = enemy.hp


func back_moves() -> void:
	$non_shadowed/moves_menu.hide()
	$shadowed/shad.hide()
func refreshbars():
	$shadowed/Player/HPBar.value = player.hp
	$shadowed/Enemy/Enemy_HP.value = enemy.hp

func move_1() -> void:
	match $non_shadowed/moves_menu/Move1.text:
		"Slap" :
			Moves.slap("player")
			
	turn = false
	$non_shadowed/moves_menu.hide()
	$shadowed/shad.hide()
	refreshbars()
	enemy_turn()
func textudt(text):
	$shadowed/text_box/text.text = text
func enemy_turn():
	match enemy.mov1:
		1:
			Moves.slap("enemy")
		
