#Derives
extends Control
#Imports
var Spawner = preload("res://Data/Spawning.gd").new()
var GMon = preload("res://Data/GenMon.gd").new()
var Save = preload("res://Data/Save.gd").new()
var Load = preload("res://Data/Load.gd").new()
var MoveLoader = preload("res://Data/MoveLoader.gd").new()
var LevelUpdater = preload("res://Data/Level_updater.gd").new()
var Damage = preload("res://Data/DamageFormula.gd").new()
var BattleChecker = preload("res://Data/Battles.gd").new()
#Globals
var Player : Dictionary
var Enemy : Dictionary
var isTrainer : bool = false
var TrainerData : Dictionary
#Ready
func _ready():
	if Globals.loaded == false:
		Player = GMon.MonGen(Globals.starter,true,0)
		Player["MOVES"]=MoveLoader.init(Player)
		Player = LevelUpdater.update_level(Player)
	else:
		var data = Load.loadfile()
		if data == null:
			get_tree().change_scene_to_file("res://scenes/Menu.tscn")
			return
		Globals.starter = data[0]
		Player = data[1]
		Globals.money = data[2]
		Globals.mon1 = data[3]
		Globals.mon2 = data[4]
		Globals.mon3 = data[5]
		Globals.mon4 = data[6]
		Globals.mon5 = data[7]
		Globals.mon6 = data[8]
		Globals.index = data[9]
		match Globals.index:
			1:
				Player = Globals.mon1
			2:
				Player = Globals.mon2
			3:
				Player = Globals.mon3
			4:
				Player = Globals.mon4
			5:
				Player = Globals.mon5
			6:
				Player = Globals.mon6
	Globals.moves = Player.MOVES
	var checker = BattleChecker.Check()
	if checker != null:
		isTrainer = true
		Enemy = checker.party.mon1
		TrainerData = checker
		$UI.textedit(checker.text)
	var e_mon = Spawner.Spawn(1)
	Enemy = GMon.MonGen(e_mon,false,0)
	Enemy["MOVES"]=MoveLoader.init(Enemy)
	Enemy = LevelUpdater.update_level(Enemy)
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
		if isTrainer == true:
			var incer = Enemy.index
			TrainerData["mon"+Enemy.index] = {}
			incer += 1
			Enemy = TrainerData["mon"+incer]
			
		#play vic music if wild or if last trainers mon
		Globals.BattleID += 1
		$UI.faint("Enemy")
		$UI.textedit("Enemy fainted!")
		Player.exp += Enemy.level * 12
		$UI.update_exp()
		if Player.exp >= Player.max_exp:
			Player = LevelUpdater.update_level(Player)
			$UI.update_exp()
		SaveMon(Player)
		Save.savefile(Player,Globals.money,Globals.starter,Globals.mon1,Globals.mon2,Globals.mon3,Globals.mon4,Globals.mon5,Globals.mon6,Globals.index)
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
		GMon.MonGen(Globals.starter,false,0)
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
func Bag() -> void:
	$UI.disable_btns(true)
	$Cast/darken.visible = true
	$Castless/Bag.visible = true
	$Castless/bag_exit.show()
	$Bag.update_bag()
func SaveMon(Entity : Dictionary) -> void:
	match Entity.index:
		1:
			Globals.mon1 = Entity
			Globals.index = 1
		2:
			Globals.mon2 = Entity
			Globals.index = 2
		3:
			Globals.mon3 = Entity
			Globals.index = 3
		4:
			Globals.mon4 = Entity
			Globals.index = 4
		5:
			Globals.mon5 = Entity
			Globals.index = 5
		6:
			Globals.mon6 = Entity
			Globals.index = 6
