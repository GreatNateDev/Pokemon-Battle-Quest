extends Control
var one
var two
var three
@export var button_1 : TextureButton
@export var button_2 : TextureButton
@export var button_3 : TextureButton
@export var label_1 : Label
@export var label_2 : Label
@export var label_3 : Label
func _ready() -> void:
	var file = FileAccess.open("res://Data/buyable_items.json", FileAccess.READ)
	var json : Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	var length = len(json.items)
	one = json.items[randi_range(0, length - 1)]
	two = json.items[randi_range(0, length - 1)]
	three = json.items[randi_range(0, length - 1)]
	button_1.texture_normal = load("res://assets/items/"+one.name+".png")
	button_2.texture_normal = load("res://assets/items/"+two.name+".png")
	button_3.texture_normal = load("res://assets/items/"+three.name+".png")
	label_1.text = str(one.description)+"\nPrice: "+str(one.price)
	label_2.text = str(two.description)+"\nPrice: "+str(two.price)
	label_3.text = str(three.description)+"\nPrice: "+str(three.price)

func skip() -> void:
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")



func three_pressed() -> void:
	if Globals.money >= three.price:
		Globals.money -= three.price
		Globals.items[three.name] += 1


func two_pressed() -> void:
	if Globals.money >= two.price:
		Globals.money -= two.price
		Globals.items[two.name] += 1

func one_pressed() -> void:
	if Globals.money >= one.price:
		Globals.money -= one.price
		Globals.items[one.name] += 1
