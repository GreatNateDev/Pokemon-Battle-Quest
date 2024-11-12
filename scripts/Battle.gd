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
	MoveLoader.init(Player)
#Events