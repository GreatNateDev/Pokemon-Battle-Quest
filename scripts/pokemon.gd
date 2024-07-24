extends Control
var pkmn = {
	"zigzagoon": zigzagoon,
	"mudkip": mudkip,
}
signal pkmn_data(pkmn)
@export var zigzagoon = {
	"name" : "zigzagoon",
	"Eposy" : "181",
	"Eposx" : "-224",
	"Pposx" : "333",
	"Pposy" : "-159",
	"type" : "normal",
	"Pscalex" : "3",
	"Pscaley" : "3",
	"Escalex" : "3",
	"Escaley" : "3",
}
@export var mudkip = {
	"type" : "water"
}


func _on_main_window_type_requester(pokemon):
	var data = pkmn.get(pokemon, {})
	print(data)
	pkmn_data.emit(data.type)
