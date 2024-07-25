extends Control
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
@export var pkmn = {
	"zigzagoon": zigzagoon,
	"mudkip": mudkip,
	"torchic": torchic,
}

func _on_main_window_type_requester(pokemon):
	var data = pkmn.get(pokemon)
	pkmn_data.emit(data.type)
