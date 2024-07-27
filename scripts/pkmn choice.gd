extends Control
func data(mon):
	Globals.starter = mon
	get_tree().change_scene_to_file("res://scenes/main_window.tscn")
func _on_zigzagoon_pressed():
	data("zigzagoon")
func _on_mudkip_pressed():
	data("mudkip")
func _on_torchic_pressed():
	data("torchic")
func _on_load_pressed():
	if ResourceLoader.exists("user://save/Data.tres") == true:
		Globals.loader = true
		get_tree().change_scene_to_file("res://scenes/main_window.tscn")
	else:
		$Label2.text = "Sorry! no save was detected"


func guide():
	get_tree().change_scene_to_file("res://scenes/guide.tscn")


func Changelog():
	get_tree().change_scene_to_file("res://scenes/changelog.tscn")
