#Derives
extends Control
#Imports
var GMon = preload("res://Data/GenMon.gd").new()
var Init = preload("res://Data/Init.gd").new()
var Save = preload("res://Data/Save.gd").new()
var MoveLoader = preload("res://Data/MoveLoader.gd").new()
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
	$BattleAnimations.Animation($Cast/Player/Player_sprite,$Cast/Enemy/Enemy_sprite,$Castless/Box_and_buttons_centre/Move1.text)
	$UI.endFight()
func Move2() -> void:
	$BattleAnimations.Animation($Cast/Player/Player_sprite,$Cast/Enemy/Enemy_sprite,$Castless/Box_and_buttons_centre/Move2.text) 
	$UI.endFight()
func Move3() -> void:
	$BattleAnimations.Animation($Cast/Player/Player_sprite,$Cast/Enemy/Enemy_sprite,$Castless/Box_and_buttons_centre/Move3.text)
	$UI.endFight()
func Move4() -> void:
	$BattleAnimations.Animation($Cast/Player/Player_sprite,$Cast/Enemy/Enemy_sprite,$Castless/Box_and_buttons_centre/Move4.text)
	$UI.endFight()