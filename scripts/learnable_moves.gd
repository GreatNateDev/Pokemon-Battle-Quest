extends Control

# Signals
signal Mov_return(mov)
signal return_lvlup_mov(mov)
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

#Bug
var caterpie = ["Tackle"]
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
	"caterpie": caterpie,
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


func _on_main_window_get_new_move(data) -> void:
	var index = data.level / 3
	index = int(index)
	var mon = data.name
	if index >= 0 and index < pkmn[mon].size():
		var move = pkmn[mon][index]
		return_lvlup_mov.emit(move)
	else:
		print("Index out of range: ", index)
		return
