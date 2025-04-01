class_name Battles
var TrainerLoader = preload("res://Data/Trainers.gd").new()
func Check():
	var BattleID : int = Globals.BattleID
	match BattleID:
		5:
			return TrainerLoader.Check(1)
		10:
			return 2 
		15:
			return 3
		20:
			return 4
		_:
			return null
