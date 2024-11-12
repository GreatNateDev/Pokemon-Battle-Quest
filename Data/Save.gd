func savefile(Player,money):
    if FileAccess.file_exists("user://Pokemon.save"):
        var file = FileAccess.open("user://Pokemon.save", FileAccess.READ_WRITE)
        Player = JSON.stringify(Player)
        money = JSON.stringify(money)
        file.store_string(Player)
        file.store_string(money)
        file.close()