extends Control
var loc_one
var price_one
var loc_two
var price_two
var loc_three
var price_three
var one
var two
var three
func _ready():
	$Label/Label.text = "Pokedolars: " + str(Globals.money)+"\n press z to skip"
	var items = itemlist.new()
	one = items.list.pick_random()
	two = items.list.pick_random()
	three = items.list.pick_random()
	
	$"Panel one/Panel/TextureButton".texture_normal = load("res://assets/items/" + str(one) + ".png")
	$"Panel two/Panel2/TextureButton".texture_normal = load("res://assets/items/" + str(two) + ".png")
	$"Panel three/Panel3/TextureButton".texture_normal = load("res://assets/items/" + str(three) + ".png")
	
	loc_one = items.list.find(one)
	price_one = items.prices[loc_one]
	loc_two = items.list.find(two)
	price_two = items.prices[loc_two]
	loc_three = items.list.find(three)
	price_three = items.prices[loc_three]
	
	$"Panel one/Panel/Label".text = str(price_one) + "$"
	$"Panel two/Panel2/Label".text = str(price_two) + "$"
	$"Panel three/Panel3/Label".text = str(price_three) + "$"
	Globals.back_shop = true




func oone():
	if Globals.money >= price_one:
		Globals.money -= price_one 
		Globals.item = one
	get_tree().change_scene_to_file("res://scenes/main_window.tscn")

func otwo():
	if Globals.money >= price_two:
		Globals.money -= price_two
		Globals.item = two
	get_tree().change_scene_to_file("res://scenes/main_window.tscn")

func othree():
	if Globals.money >= price_three:
		Globals.money -= price_three
		Globals.item = three
	get_tree().change_scene_to_file("res://scenes/main_window.tscn")
func _input(event):
	if event.is_action_pressed("z"):
		get_tree().change_scene_to_file("res://scenes/main_window.tscn")
