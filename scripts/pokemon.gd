extends Control
class_name pokemon
signal pkmn_data(pkmn)
@export var zigzagoon = {
	"type": "Normal"
}
@export var mudkip = {
	"type" : "Water"
}
@export var torchic = {
	"type" : "Fire"
}
@export var treecko = {
	"type" : "Grass"
}
@export var pkmn = {
	"zigzagoon": zigzagoon,
	"treecko": treecko,
	"mudkip": mudkip,
	"torchic": torchic,
}

func _on_main_window_type_requester(pokemoner):
	var data = pkmn.get(pokemoner)
	pkmn_data.emit(data.type)
