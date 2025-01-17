class_name Trainers
var LevelLoader = preload("res://Data/Level_updater.gd").new()
var MoveLoader = preload("res://Data/MoveLoader.gd").new()
var GMon = preload("res://Data/GenMon.gd").new()
func Check(id):
	match id:
		1:
			var rival_mon : String
			match Globals.starter:
				"charmander": 
					rival_mon = "squirtle"
				"bulbasaur":
					rival_mon = "charmander"
				"squirtle":
					rival_mon = "bulbasaur"
			CreateTrainer("Gray","You're about to get smashed kid",3,[rival_mon,null,null,null,null,null])
		2:
			pass
		3:
			pass
		4:
			pass
			
			
func CreateTrainer(Name,Text,Level,Party):
	Party = CreateParty(Party,Level)
	return {
		"name": Name,
		"text": Text,
		"party": Party
	}
func CreateParty(Party,Level):
	var returnable_dict : Dictionary
	var incrementer : int = 1
	for i in Party:
		if i == null: break
		var e = GMon.MonGen(i,false)
		e = MoveLoader.init(e)
		e = LevelLoader.update_level(e)
		returnable_dict["mon"+str(incrementer)] = e
		incrementer += 1
			
