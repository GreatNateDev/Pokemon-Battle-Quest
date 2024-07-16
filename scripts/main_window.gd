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
	set_types()
	refine_level_stats(Player,false)
	refine_level_stats(Enemy,false)
	reset_bars()
	cap_bars()
	set_levels()
	set_max_exp()
func refine_level_stats(entity,lvlup):
	if lvlup == false:
		entity.hp += entity.level
		entity.spd += entity.level
		entity.atk += entity.level
		entity.def += entity.level
	elif lvlup == true:
		var old_hp = entity.hp
		var old_spd = entity.spd
		var old_atk = entity.atk
		var old_def = entity.def
		entity.hp += entity.level
		entity.spd += entity.level
		entity.atk += entity.level
		entity.def += entity.level
		textedit("You leveled up! here are you're old VS new stat HP "+str(old_hp)+" > "+str(entity.hp)+"\nSPEED "+str(old_spd)+" > "+str(entity.spd)+"\nATTACK "+str(old_atk)+" > "+str(entity.atk)+"\nDEFENSE "+str(old_def)+" > "+str(entity.def))
func set_types():
	$Cast/Player/type.text = Player.type
	$Cast/Enemy/type.text = Enemy.type
func randomize_player():
	Player = {
		"level" : randi_range(5,7),
		"hp" : randi_range(20,25),
		"spd" : randi_range(1,5),
		"atk" : randi_range(1,5),
		"def" : randi_range(1,5),
		"type": "Normal",
		"exp": 0,
		"max_exp": null
	}
func _process(delta: float) -> void:
	pass
func random_enemy_level_one():
	Enemy = {
		"level" : randi_range(5,7),
		"hp" : randi_range(15,20),
		"spd" : randi_range(1,5),
		"atk" : randi_range(1,5),
		"def" : randi_range(1,5),
		"move1": randmov(),
		"move2": randmov(),
		"move3": randmov(),
		"move4": randmov(),
		"current": null,
		"type": "Normal"
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
	var tween = get_tree().create_tween()
	tween.tween_property($Cast/textbox/Label,"text",text,.3)
func _on_moves_damage(entity, damage, text):
	await get_tree().create_timer(.5).timeout
	if entity == "Enemy":
		Player.hp -= damage
		disable_btns(false)
		var tween = get_tree().create_tween()
		tween.tween_property($Cast/Player/hpbar,"value",Player.hp,1).set_trans(Tween.TRANS_LINEAR)
	elif entity == "Player":
		Enemy.hp -= damage
		var tween = get_tree().create_tween()
		tween.tween_property($Cast/Enemy/hpbar,"value",Enemy.hp,1).set_trans(Tween.TRANS_LINEAR)
		if Enemy.hp <= 0:
			textedit(text)
			await get_tree().create_timer(1).timeout
			kill_enemy()
			return
		$"after_attack cooldown".start()
	textedit(text)
	
func Enemy_atk():
	var pick = randi_range(1,4)
	if pick == 1:
		Enemy.current = Enemy.move1
	elif pick == 2:
		Enemy.current = Enemy.move2
	elif pick == 3:
		Enemy.current = Enemy.move3
	elif pick == 4:
		Enemy.current = Enemy.move4
	Attack.emit(Enemy.current,"Enemy",Enemy,Player)
func _on_after_attack_cooldown_timeout():
	Enemy_atk()
func randmov():
	var movs = randi_range(1,2)
	match movs:
		1:
			return "Slap"
		2:
			return "Kick"


func text_from_moves(text,unblocked,entity):
	textedit(text)
	if unblocked == true:
		disable_btns(false)
	if entity == "Player":
		$"after_attack cooldown".start()


func run_clicked():
	var run_chance = randi_range(1,2)
	if run_chance == 1:
		textedit("You ran away!")
		await get_tree().create_timer(2).timeout
		random_enemy_level_one()
		reset_bars()
		cap_bars()
		textedit("You encountered another enemy! and healed up!")
	elif run_chance == 2:
		textedit("You failed to run away!")
		disable_btns(true)
		await get_tree().create_timer(2).timeout
		Enemy_atk()
func set_levels():
	$Cast/Player/lvl.text = "Level: "+str(Player.level)
	$Cast/Enemy/lvl.text = "Level: "+str(Enemy.level)


func Move2() -> void:
	Attack.emit($Castless/Box_and_buttons_centre/Move2.text,"Player",Player,Enemy)
	$Cast/darken.hide()
	$Castless/Box_and_buttons_centre.hide()
func kill_enemy():
	$AnimationPlayer.play("Enemy_death")
	add_exp(Enemy.level * 10)
	players_turn = true
	await get_tree().create_timer(2).timeout
	random_enemy_level_one()
	$AnimationPlayer.play_backwards("Enemy_death")
	reset_bars()
	cap_bars()
	reset_bars()
	disable_btns(false)
func add_exp(amt):
	Player.exp += amt
	var tween = get_tree().create_tween()
	tween.tween_property($Cast/Player/xpbar,"value",Player.exp,1)
	if Player.exp >= Player.max_exp:
		level_up()
	
func level_up():
	await get_tree().create_timer(1).timeout
	Player.exp = 0
	Player.level += 1
	refine_level_stats(Player,true)
	set_max_exp()
	set_levels()
	$Cast/Player/xpbar.value = 0
func set_max_exp():
	Player.max_exp = Player.level * 30
	$Cast/Player/xpbar.max_value = Player.max_exp
