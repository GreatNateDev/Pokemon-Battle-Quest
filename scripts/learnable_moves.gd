extends Control

# Signals
signal Mov_return(mov)

# Water
var totodile = ["Watergun", "Tackle"]
var mudkip = ["Watergun", "Tackle"]
var squirtle = ["Watergun", "Tackle"]

# Grass
var treecko = ["Absorb"]
var bulbasaur = ["Absorb", "Tackle"]
var chikorita = ["Absorb", "Tackle"]

# Fire
var torchic = ["Ember"]
var charmander = ["Ember"]
var cyndaquil = ["Ember", "Tackle"]

# Normal
var zigzagoon = ["Bite", "Tackle"]

# Mons
var pkmn = {
	"zigzagoon": zigzagoon,
	"treecko": treecko,
	"mudkip": mudkip,
	"torchic": torchic,
	"totodile": totodile,
	"bulbasaur": bulbasaur,
	"charmander": charmander,
	"squirtle": squirtle,
	"cyndaquil": cyndaquil,
	"chikorita": chikorita,
}

func RandMov(mon):
	var value = pkmn[mon]
	var used_moves = []
	for i in range(4):
		var available_moves = value.filter(func(mov):
			return not used_moves.has(mov)
		)
		if available_moves.size() == 0:
			Mov_return.emit("")
		else:
			var rand = randi() % available_moves.size()
			var output = available_moves[rand]
			used_moves.append(output)
			Mov_return.emit(output)
