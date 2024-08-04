extends Control
class_name pokemon
signal pkmn_data(pkmn)
@export var zigzagoon = {
	"type": "Normal",
	"type2": "none",
	"catch" : 255
}
@export var mudkip = {
	"type" : "Water",
	"type2": "none",
	"catch" : 45
}
@export var torchic = {
	"type" : "Fire",
	"type2": "none",
	"catch" : 45
}
@export var treecko = {
	"type" : "Grass",
	"type2": "none",
	"catch" : 45
}
@export var pkmn = {
	"zigzagoon": zigzagoon,
	"treecko": treecko,
	"mudkip": mudkip,
	"torchic": torchic,
}

func _on_main_window_type_requester(pokemoner):
	var data = pkmn.get(pokemoner)
	pkmn_data.emit(data.type,pokemoner,data.type2)
