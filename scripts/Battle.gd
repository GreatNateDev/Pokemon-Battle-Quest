#Derives
extends Control
#Imports
var GMon = preload("res://Data/GenMon.gd").new()
var Save = preload("res://Data/Save.gd").new()
var Load = preload("res://Data/Load.gd").new()
var MoveLoader = preload("res://Data/MoveLoader.gd").new()
var Damage = preload("res://Data/DamageFormula.gd").new()
#Globals
var Player : Dictionary
var Enemy : Dictionary
#Ready
func _ready():
	if Globals.loaded == false:
		Player = GMon.MonGen(Globals.starter)
		Player["MOVES"]=MoveLoader.init(Player)
	else:
		var data = Load.loadfile()
		if data == null:
			get_tree().change_scene_to_file("res://scenes/Menu.tscn")
			return
		Globals.starter = data[0]
		Player = data[1]
		Globals.money = data[2]
	Globals.moves = Player.MOVES
	Enemy = GMon.MonGen(Globals.starter)
	Enemy["MOVES"]=MoveLoader.init(Enemy)
	update_level(Player)
	update_level(Enemy)
	$UI.init(Player,Enemy)
#Events
func Move1() -> void:
	Fight($Castless/Box_and_buttons_centre/Move1.text)
	$BattleAnimations.Animation($Cast/Player/Player_sprite,$Cast/Enemy/Enemy_sprite,$Castless/Box_and_buttons_centre/Move1.text)
func Move2() -> void:
	Fight($Castless/Box_and_buttons_centre/Move2.text)
	$BattleAnimations.Animation($Cast/Player/Player_sprite,$Cast/Enemy/Enemy_sprite,$Castless/Box_and_buttons_centre/Move2.text) 
func Move3() -> void:
	Fight($Castless/Box_and_buttons_centre/Move3.text)
	$BattleAnimations.Animation($Cast/Player/Player_sprite,$Cast/Enemy/Enemy_sprite,$Castless/Box_and_buttons_centre/Move3.text)
func Move4() -> void:
	Fight($Castless/Box_and_buttons_centre/Move4.text)
	$BattleAnimations.Animation($Cast/Player/Player_sprite,$Cast/Enemy/Enemy_sprite,$Castless/Box_and_buttons_centre/Move4.text)
func Fight(move) -> void:
	$UI.endFight()
	var d = Damage.Attack(move,"Player",Player,Enemy)
	Enemy.hp -= d[0]
	$UI.textedit(d[1])
	$UI.reset_bars("Enemy",Enemy.hp)
	$UI.disable_btns(true)
	if Enemy.hp <= 0:
		#add triggers for below if trainer
		#play vic music if wild or if last trainers mon
		$UI.faint("Enemy")
		$UI.textedit("Enemy fainted!")
		Player.exp += Enemy.level * 12
		$UI.update_exp()
		if Player.exp >= Player.max_exp:
			update_level(Player)
			$UI.update_exp()
		Save.savefile(Player,Globals.money,Globals.starter)
		await get_tree().create_timer(2.5).timeout
		Globals.loaded = true
		get_tree().change_scene_to_file("res://scenes/Shop.tscn")
		return
	await get_tree().create_timer(2.5).timeout
	move = randi_range(0, len(Enemy.MOVES) - 1)
	move = Enemy.MOVES[move]
	$BattleAnimations.Animation($Cast/Enemy/Enemy_sprite,$Cast/Player/Player_sprite,move)
	d = Damage.Attack(move,"Enemy",Enemy,Player)
	Player.hp -= d[0]
	if Player.hp <= 0:
		#add triggers for below if has more mon
		$UI.faint("Player")
	$UI.textedit(d[1])
	$UI.reset_bars("Player",Player.hp)
	$UI.disable_btns(false)
func Run() -> void:
	var chance = (Player.speed / Enemy.speed) * 128
	var rand = randi() % 256
	if chance > rand:
		$UI.textedit("Got away safely!")
		GMon.MonGen(Globals.starter)
	else:
		$UI.textedit("Can't escape!")
		$UI.disable_btns(true)
		await get_tree().create_timer(2.5).timeout
		var move = randi_range(0, len(Enemy.MOVES) - 1)
		move = Enemy.MOVES[move]
		$BattleAnimations.Animation($Cast/Enemy/Enemy_sprite,$Cast/Player/Player_sprite,move)
		var d = Damage.Attack(move,"Enemy",Enemy,Player)
		Player.hp -= d[0]
		if Player.hp <= 0:
			#add triggers for below if has more mon
			$UI.faint("Player")
		$UI.textedit(d[1])
		$UI.reset_bars("Player",Player.hp)
		$UI.disable_btns(false)
func update_level(Entity : Dictionary) -> Dictionary:
	Entity.max_exp = Entity.level * 100
	Entity.exp = 0
	var stats = FileAccess.open("res://Data/Pokemon.json", FileAccess.READ)
	stats = JSON.parse_string(stats.get_as_text())
	stats = stats[Entity.name].stats
	Entity.hp = stats.Hp
	Entity.attack = stats.Attack
	Entity.defense = stats.Defense
	Entity.spattack = stats.SpAttack
	Entity.spdefense = stats.SpDefense
	Entity.speed = stats.Speed
	Entity.hp += Entity.IVS.hp
	Entity.attack += Entity.IVS.attack
	Entity.defense += Entity.IVS.defense
	Entity.spattack += Entity.IVS.spattack
	Entity.spdefense += Entity.IVS.spdefense
	Entity.speed += Entity.IVS.speed
	Entity.hp += Entity.EVS.hp
	Entity.attack += Entity.EVS.attack
	Entity.defense += Entity.EVS.defense
	Entity.spattack += Entity.EVS.spattack
	Entity.spdefense += Entity.EVS.spdefense
	Entity.speed += Entity.EVS.speed
	return Entity
func Bag() -> void:
	$UI.disable_btns(true)
	$Cast/darken.visible = true
	$Castless/Bag.visible = true
	$Castless/bag_exit.show()
	$Bag.update_bag()
	
	
