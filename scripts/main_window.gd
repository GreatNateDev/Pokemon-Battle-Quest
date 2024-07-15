extends Control
var players_turn = true
var Player = null
var Player2 = null
var Player3 = null
var Player4 = null
var Player5 = null
var Player6 = null
var Enemy = null
func _ready():
	randomize_player()
	random_enemy_level_one()
	reset_bars()
	
func randomize_player():
	Player = {
		"hp" : randi_range(20,25),
		"spd" : randi_range(1,5),
		"atk" : randi_range(1,5),
		"def" : randi_range(1,5)
	}
func random_enemy_level_one():
	Enemy = {
		"hp" : randi_range(15,20),
		"spd" : randi_range(1,5),
		"atk" : randi_range(1,5),
		"def" : randi_range(1,5)
	}
func reset_bars():
	$Cast/Player/hpbar.value = Player.hp
	$Cast/Enemy/hpbar.value = Enemy.hp


func damage(entity, damage):
	if entity == "player":
		Player.hp -= damage
