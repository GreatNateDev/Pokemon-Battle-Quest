extends Control


func _on_zigzagoon_pressed():
	Globals.starter = "zigzagoon"
	get_tree().change_scene_to_file("res://scenes/main_window.tscn")

func _on_mudkip_pressed():
	Globals.starter = "mudkip"
	get_tree().change_scene_to_file("res://scenes/main_window.tscn")


func _on_torchic_pressed():
	pass # Replace with function body.
