extends Control
func _ready():
	$Label.text = "Pokedolars: " + str(Globals.money)
	var items = itemlist.new()
	var one = items.list.pick_random()
	var two = items.list.pick_random()
	var three = items.list.pick_random()
	
	$Panel/TextureButton.texture_normal = load("res://assets/items/" + str(one) + ".png")
	$Panel2/TextureButton.texture_normal = load("res://assets/items/" + str(two) + ".png")
	$Panel3/TextureButton.texture_normal = load("res://assets/items/" + str(three) + ".png")
	
	var loc_one = items.list.find(one)
	var price_one = items.prices[loc_one]
	var loc_two = items.list.find(two)
	var price_two = items.prices[loc_two]
	var loc_three = items.list.find(three)
	var price_three = items.prices[loc_three]
	
	$Panel/Label.text = str(price_one) + "$"
	$Panel2/Label.text = str(price_two) + "$"
	$Panel3/Label.text = str(price_three) + "$"
