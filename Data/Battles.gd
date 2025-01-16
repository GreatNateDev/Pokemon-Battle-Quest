class_name Battles
func Check():
	var : int BattleID = Globals.BattleID
	match BattleID:
		5:
			return 1
		10:
			return 2 
		15:
			return 3
		20:
			return 4