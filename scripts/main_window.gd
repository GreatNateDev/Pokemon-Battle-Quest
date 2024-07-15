extends Control
signal Attack(Move,Entity,Stats,OStats)
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
	cap_bars()
func _process(delta):
	print(Enemy.hp)
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
func cap_bars():
	$Cast/Player/hpbar.max_value = Player.hp
	$Cast/Enemy/hpbar.max_value = Enemy.hp

func disable_btns(value):
	$Cast/Buttons/Fight.disabled = value
	$Cast/Buttons/Run.disabled = value
	$Cast/Buttons/Bag.disabled = value
	$Cast/Buttons/Swap.disabled = value
	

func Move1():
	Attack.emit($Castless/Box_and_buttons_centre/Move1.text,"Player",Player,Enemy)
	$Cast/darken.hide()
	$Castless/Box_and_buttons_centre.hide()


func _on_fight_pressed():
	$Cast/darken.show()
	$Castless/Box_and_buttons_centre.show()
	disable_btns(true)
	
	

func textedit(text):
	$Cast/textbox/Label.text = text
func _on_moves_damage(entity, damage, text):
	if entity == "Enemy":
		Player.hp -= damage
	elif entity == "Player":
		Enemy.hp -= damage
	reset_bars()
	textedit(text)
	


func _on_after_attack_cooldown_timeout():
	#Enemy_atk()
	pass
