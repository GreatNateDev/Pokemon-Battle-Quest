extends Control

func _ready():
	var text = FileAccess.get_file_as_string("res://README.md")
	text = text.replace("\\","")
	text = text.replace("_","")
	text = text.replace("~","")
	$Label.text = text
func _process(_delta):
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://scenes/pkmn choice.tscn")
