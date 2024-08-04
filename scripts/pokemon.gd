extends Control
class_name pokemon
signal pkmn_data(pkmn)
var totodile = {"type": "Water", "type2": "none", "catch": 45}
var bulbasaur = {"type": "Grass", "type2": "Poison", "catch": 45}
var charmander = {"type": "Fire", "type2": "none", "catch": 45}
var squirtle = {"type": "Water", "type2": "none", "catch": 45}
var cyndaquil = {"type": "Fire", "type2": "none", "catch": 45}
var chikorita = {"type": "Grass", "type2": "none", "catch": 45}
var zigzagoon = {"type": "Normal", "type2": "none", "catch" : 255}
var mudkip = {"type" : "Water", "type2": "none", "catch" : 45}
var torchic = {"type" : "Fire", "type2": "none", "catch" : 45}
var treecko = {"type" : "Grass","type2": "none","catch" : 45}
var pkmn = {
	"zigzagoon": zigzagoon,
	"treecko": treecko,
	"mudkip": mudkip,
	"torchic": torchic,
	"totodile": totodile,
	"bulbasaur":bulbasaur,
	"charmander":charmander,
	"squirtle": squirtle,
	"cyndaquil": cyndaquil,
	"chikorita": chikorita,
}

func _on_main_window_type_requester(pokemoner):
	var data = pkmn.get(pokemoner)
	pkmn_data.emit(data.type,pokemoner,data.type2)
