extends Control
class_name util
signal Save_Changed()
var data
func _process(_delta: float) -> void:
	data = get_parent().get_node(".").data
func bars():
	$"/root/Main_Window/Cast/Player/hpbar".value = data.Player.hp
	$"/root/Main_Window/Cast/Player/hpbar".max_value = data.Player.max_hp
	$"/root/Main_Window/Cast/Enemy/hpbar".value = data.Enemy.hp
	$"/root/Main_Window/Cast/Enemy/hpbar".max_value = data.Enemy.max_hp
func GenPlayer():
	data.Player = {
		"hp": randi_range(1,5),
		"atk": randi_range(1,5),
		"def": randi_range(1,5),
		"spd": randi_range(1,5),
		"max_hp": 1,
	}
	data.Player.max_hp = data.Player.hp
	Save_Changed.emit(data)
func save_data():
	var d = DirAccess.open("user://")
	if d.dir_exists("Saves"):
		ResourceSaver.save(data, "user://Saves/save.sav")
	elif not d.dir_exists("Saves"):
		d.make_dir("Saves")
		ResourceSaver.save(data, "user://Saves/save.sav")
func load_data():
	if ResourceLoader.exists("user://Saves/save.sav"):
		var loaded_data = ResourceLoader.load("user://Saves/save.sav")
		if loaded_data:
			data = loaded_data
			return true
	return false
