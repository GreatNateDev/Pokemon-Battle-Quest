extends Control
var first_start = true
var player : Dictionary
var enemy : Dictionary
func _process(delta: float) -> void:
	if first_start == true:
		randize_ivs()
		$Player/HPBar.max_value = player.hp
		$Player/HPBar.value = player.hp
		summon_lvl_one()
		first_start = false
	


func fight() -> void:
	$moves_menu.show()
	
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
	$Enemy/Enemy_HP.max_value = enemy.hp
	$Enemy/Enemy_HP.value = enemy.hp
