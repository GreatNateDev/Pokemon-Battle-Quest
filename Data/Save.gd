func savefile(Player,money,starter):
	print("ft run") 
	DirAccess.make_dir_absolute("user://Saves")
	var file = FileAccess.open("user://Saves/Pokemon.save", FileAccess.WRITE)
	if file == null:
		var err_str := error_string(FileAccess.get_open_error())
		push_warning("Failed to open save file because: ", err_str)
		return
	starter = JSON.stringify(starter)
	Player = JSON.stringify(Player)
	money = JSON.stringify(money)
	file.store_line(starter)
	file.store_line(Player)
	file.store_line(money)
	file.close()
