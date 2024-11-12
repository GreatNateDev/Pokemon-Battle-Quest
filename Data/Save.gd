func savefile(Player):
    if FileAccess.file_exists("user://Pokemon.save"):
        var file = FileAccess.open("user://Pokemon.save", FileAccess.READ_WRITE)
        Player = JSON.stringify(Player)
        file.store_string(Player)