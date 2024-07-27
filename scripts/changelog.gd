extends Control

func _ready():
	var text = FileAccess.get_file_as_string("res://README.md")
	$Label.text = text
func _process(delta):
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://scenes/pkmn choice.tscn")
