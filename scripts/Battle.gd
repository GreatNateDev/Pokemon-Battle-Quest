#Derives
extends Control
#Imports
var GMon = preload("res://Data/GenMon.gd").new()
var Init = preload("res://Data/Init.gd").new()
var Save = preload("res://Data/Save.gd").new()
#Ready
func _ready():
	var Player = GMon.MonGen(Globals.starter)
	Player["exp"] = 0
	Player["max_exp"] = Player.level * 100
	var Enemy = GMon.MonGen(Globals.starter)
	$UI.init(Player,Enemy)
