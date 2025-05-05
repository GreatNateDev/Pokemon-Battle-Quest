class_name Battles
var TrainerLoader = preload("res://Data/Trainers.gd").new()
func Check():
	var BattleID : int = Globals.BattleID
	match BattleID:
		5:
			return null  #TrainerLoader.Check(1)
		10:
			return null
		15:
			return null
		20:
			return null
		_:
			return null
