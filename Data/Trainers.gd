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
			return CreateTrainer("Gray","You're about to get smashed kid",3,[rival_mon,null,null,null,null,null],1)
		2:
			pass
		3:
			pass
		4:
			pass
			
			
func CreateTrainer(Name: String ,Text: String , Level : int , Party: Array , amt : int ):
	var NewParty = CreateParty(Party,Level)
	return {
		"name": Name,
		"text": Text,
		"amt": amt,
		"party": NewParty
	}
func CreateParty(Party,Level):
	var returnable_dict : Dictionary = {"mon1": null,"mon2":null,"mon3":null,"mon4":null,"mon5":null,"mon6":null}
	var incrementer : int = 1
	for i in Party:
		if i == null: break
		var e = GMon.MonGen(i,false,incrementer)
		e["MOVES"]=MoveLoader.init(e)
		e = LevelLoader.update_level(e)
		e.level = Level
		returnable_dict["mon"+str(incrementer)] = e
		incrementer += 1
	return returnable_dict
