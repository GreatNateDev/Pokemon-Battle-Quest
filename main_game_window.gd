extends Control
@onready var player : Dictionary
@onready var enemy : Dictionary
@onready var turn = true
@onready var hpbar = get_parent().get_node("/root/exec/shadowed/Player/HPBar")
@onready var ehpbar = get_parent().get_node("/root/exec/shadowed/Enemy/Enemy_HP")
@onready var textbox = get_parent().get_node("/root/exec/shadowed/text_box/text")
func _ready() -> void:
	randize_ivs()
	hpbar.max_value = 10
	summon_lvl_one()
	refreshbars()
func _process(delta: float) -> void:
	if turn == false:
		$shadowed/Fight.disabled = true
	


func fight() -> void:
	$non_shadowed/moves_menu.show()
	$shadowed/shad.show()
	
func randize_ivs():
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
	print(player.hp)
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
	ehpbar.max_value = enemy.hp
	ehpbar.value = enemy.hp


func back_moves() -> void:
	$non_shadowed/moves_menu.hide()
	$shadowed/shad.hide()
func refreshbars():
	hpbar.value = player.hp
	ehpbar.value = enemy.hp

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
	textbox.text = text
func enemy_turn():
	match enemy.mov1:
		1:
			Moves.slap("enemy")
		
