func loadfile():
	DirAccess.open("user://Saves")
	if FileAccess.file_exists("user://Saves/Pokemon.save") and Globals.loaded == true:
		var file = FileAccess.open("user://Saves/Pokemon.save", FileAccess.READ)
		var starter = file.get_line().replace('"',"")
		var player_json = JSON.parse_string(file.get_line())
		var money = file.get_line().to_int()
		var mon1 = JSON.parse_string(file.get_line())
		var mon2 = JSON.parse_string(file.get_line())
		var mon3 = JSON.parse_string(file.get_line())
		var mon4 = JSON.parse_string(file.get_line())
		var mon5 = JSON.parse_string(file.get_line())
		var mon6 = JSON.parse_string(file.get_line())
		var index = file.get_line().to_int()
		return [starter,player_json,money,mon1,mon2,mon3,mon4,mon5,mon6,index]
	return null
