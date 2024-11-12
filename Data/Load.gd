func loadfile():
    if FileAccess.file_exists("user://Pokemon.save"):
        var file = FileAccess.open("user://Pokemon.save", FileAccess.READ)
        var content = file.get_as_text()
        var data = JSON.parse_string(content)
        return data
    return null
