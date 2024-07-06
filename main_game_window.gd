extends Control
var first_start = true
var player : Dictionary
var enemy : Dictionary
func _process(delta: float) -> void:
	if first_start == true:
		randize_ivs()
		$shadowed/Player/HPBar.max_value = player.hp
		$shadowed/Player/HPBar.value = player.hp
		summon_lvl_one()
		first_start = false
	


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
	enemy = {
		"class" : "very very easy",
		"hp" : hp,
		"speed" : speed,
		"def" : def,
		"atk" : atk
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
			if player.atk != 1:
				enemy.hp -= (player.atk / 2)
				textudt("Nate used slap and did "+str(player.atk / 2)+" damage!")
			else:
				enemy.hp -= 1
				textudt("Nate used slap and did 1 damage!")
	$non_shadowed/moves_menu.hide()
	$shadowed/shad.hide()
	refreshbars()
func textudt(text):
	$shadowed/text_box/text.text = text
