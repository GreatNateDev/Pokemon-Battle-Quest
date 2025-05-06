#Derives
extends Control
#Imports
var Spawner = preload("res://Data/Spawning.gd").new()
var GMon = preload("res://Data/GenMon.gd").new()
var Save = preload("res://Data/Save.gd").new()
var Load = preload("res://Data/Load.gd").new()
var MoveLoader = preload("res://Data/MoveLoader.gd").new()
var LevelUpdater = preload("res://Data/Level_updater.gd").new()
var BattleChecker = preload("res://Data/Battles.gd").new()
var Damage = preload("res://Data/DamageFormula.gd").new()
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
		Globals.loaded = false
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
		#this may be problematic
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
		Globals.trainer = checker.name
		$UI.textedit(checker.text)
		$UI.init(Player,Enemy)
		return 0
	var e_mon = Spawner.Spawn(1)
	Enemy = GMon.MonGen(e_mon,false,0)
	Enemy["MOVES"]=MoveLoader.init(Enemy)
	Enemy = LevelUpdater.update_level(Enemy)
	Enemy["max_hp"] = Enemy.hp
	Globals.p_name = Player.name
	Globals.e_name = Enemy.name
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
	Globals.p_name = Player.name
	$UI.endFight()
	var d = Damage.Attack(move,"Player",Player,Enemy)
	$UI.typesound(d[2])
	Enemy.hp -= d[0]
	$UI.textedit(d[1])
	$UI.reset_bars("Enemy",Enemy.hp)
	$UI.disable_btns(true)
	if Enemy.hp <= 0:
		if isTrainer == true:
			var incer = Enemy.index
			TrainerData["mon"+str(Enemy.index)] = {}
			incer += 1
			Enemy = TrainerData["mon"+str(incer)]
			
		#play vic music if wild or if last trainers mon
		Globals.BattleID += 1
		$UI.faint("Enemy")
		$UI.textedit("Enemy fainted!")
		Player.exp += Enemy.level * 12
		$UI.update_exp()
		if Player.exp >= Player.max_exp:
			Player = LevelUpdater.update_level(Player)
			$UI.update_exp()
		Saver()
		return
	await get_tree().create_timer(2.5).timeout
	EnemyAttack()
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
func Swap() -> void:
	$UI.UpdateSwapMenu()
func Saver() -> void:
	SaveMon(Player)
	Save.savefile(Player,Globals.money,Globals.starter,Globals.mon1,Globals.mon2,Globals.mon3,Globals.mon4,Globals.mon5,Globals.mon6,Globals.index)
	await get_tree().create_timer(2.5).timeout
	Globals.loaded = true
	get_tree().change_scene_to_file("res://scenes/Shop.tscn")
func PokemonSwap(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	if Globals.replacing == {}:
		match index:
			0:  # Switch to mon1
				if Player.index != 1 and Globals.mon1 != null:
					set("Globals.mon%d" % Player.index, Player)
					Player = Globals.mon1
				else:
					return
			1:  # Switch to mon2
				if Player.index != 2 and Globals.mon2 != null:
					set("Globals.mon%d" % Player.index, Player)
					Player = Globals.mon2
				else:
					return
			2:  # Switch to mon3
				if Player.index != 3 and Globals.mon3 != null:
					set("Globals.mon%d" % Player.index, Player)
					Player = Globals.mon3
				else:
					return
			3:  # Switch to mon4
				if Player.index != 4 and Globals.mon4 != null:
					set("Globals.mon%d" % Player.index, Player)
					Player = Globals.mon4
				else:
					return
			4:  # Switch to mon5
				if Player.index != 5 and Globals.mon5 != null:
					set("Globals.mon%d" % Player.index, Player)
					Player = Globals.mon5
				else:
					return
			5:  # Switch to mon6
				if Player.index != 6 and Globals.mon6 != null:
					set("Globals.mon%d" % Player.index, Player)
					Player = Globals.mon6
				else:
					return
	else:
		match index:
			1:
				if Player.index != 1 and Globals.mon1 != null:
					Globals.mon1 = null
					Player = Globals.replacing
					Player.index = 1
					Globals.mon1 = Player
			2:
				if Player.index != 2 and Globals.mon2 != null:
					Globals.mon2 = null
					Player = Globals.replacing
					Player.index = 2
					Globals.mon2 = Player
			3:
				if Player.index != 3 and Globals.mon3 != null:
					Globals.mon3 = null
					Player = Globals.replacing
					Player.index = 3
					Globals.mon3 = Player
			4:
				if Player.index != 4 and Globals.mon4 != null:
					Globals.mon4 = null
					Player = Globals.replacing
					Player.index = 4
					Globals.mon4 = Player
			5:
				if Player.index != 5 and Globals.mon5 != null:
					Globals.mon5 = null
					Player = Globals.replacing
					Player.index = 5
					Globals.mon5 = Player
			6:
				if Player.index != 6 and Globals.mon != null:
					Globals.mon6 = null
					Player = Globals.replacing
					Player.index = 6
					Globals.mon6 = Player
		Saver()

	Globals.p_name = Player.name
	Globals.e_name = Enemy.name
	$UI.UpdateSwapMenu()
	$UI.init(Player,Enemy)
	await get_tree().create_timer(2).timeout
	EnemyAttack()
func EnemyAttack():
	Globals.e_name = Enemy.name
	var move
	var d
	move = randi_range(0, len(Enemy.MOVES) - 1)
	move = Enemy.MOVES[move]
	$BattleAnimations.Animation($Cast/Enemy/Enemy_sprite,$Cast/Player/Player_sprite,move)
	d = Damage.Attack(move,"Enemy",Enemy,Player)
	$UI.typesound(d[2])
	Player.hp -= d[0]
	if Player.hp <= 0:
		#add triggers for below if has more mon
		$UI.faint("Player")
	$UI.textedit(d[1])
	$UI.reset_bars("Player",Player.hp)
	$UI.disable_btns(false)
