func loadfile():
    DirAccess.open("user://Saves")
    if FileAccess.file_exists("user://Saves/Pokemon.save") and Globals.loaded == true:
        var file = FileAccess.open("user://Saves/Pokemon.save", FileAccess.READ)
        var starter = file.get_line().replace('"',"")
        var player_json = JSON.parse_string(file.get_line())
        var money = file.get_line().to_int()
        print(starter)
        return [starter,player_json,money]
    return null
