extends Control


func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/pkmn choice.tscn")
