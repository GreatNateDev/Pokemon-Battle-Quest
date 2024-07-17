extends Control


func _on_zigzagoon_pressed():
	Globals.starter = "zigzagoon"
	get_tree().change_scene_to_file("res://scenes/main_window.tscn")

func _on_mudkip_pressed():
	Globals.starter = "mudkip"
	get_tree().change_scene_to_file("res://scenes/main_window.tscn")


func _on_torchic_pressed():
	Globals.starter = "torchic"
	get_tree().change_scene_to_file("res://scenes/main_window.tscn")


func _on_load_pressed():
	if ResourceLoader.exists("user://save/Data.tres") == true:
		Globals.loader = true
		get_tree().change_scene_to_file("res://scenes/main_window.tscn")
	else:
		$Label2.text = "Sorry! no save was detected"
