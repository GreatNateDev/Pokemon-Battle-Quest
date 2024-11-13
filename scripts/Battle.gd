#Derives
extends Control
#Imports
var GMon = preload("res://Data/GenMon.gd").new()
var Save = preload("res://Data/Save.gd").new()
var MoveLoader = preload("res://Data/MoveLoader.gd").new()
var Damage = preload("res://Data/DamageFormula.gd").new()
#Globals
var Player : Dictionary
var Enemy : Dictionary
#Ready
func _ready():
	Player = GMon.MonGen(Globals.starter, true)
	Enemy = GMon.MonGen(Globals.starter,false)
	$UI.init(Player,Enemy)
	Player["MOVES"]=MoveLoader.init(Player)
	Enemy["MOVES"]=MoveLoader.init(Enemy)
	Globals.moves = Player.MOVES
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
	if Enemy.hp <= 0:
		$UI.faint("Enemy")
	$UI.textedit(d[1])
	$UI.reset_bars("Enemy",Enemy.hp)
	$UI.disable_btns(true)
	await get_tree().create_timer(1.5).timeout
	move = randi_range(0, len(Enemy.MOVES) - 1)
	move = Enemy.MOVES[move]
	$BattleAnimations.Animation($Cast/Enemy/Enemy_sprite,$Cast/Player/Player_sprite,move)
	d = Damage.Attack(move,"Enemy",Enemy,Player)
	Player.hp -= d[0]
	if Player.hp <= 0:
		$UI.faint("Player")
	$UI.textedit(d[1])
	$UI.reset_bars("Player",Player.hp)
	$UI.disable_btns(false)
