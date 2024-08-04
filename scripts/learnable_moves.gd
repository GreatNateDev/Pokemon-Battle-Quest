extends Control
#Signals
signal Mov_return(mov)
#Water
var totodile = ["Watergun"]
var mudkip = ["Watergun"]
var squirtle = ["Watergun"]
#Grass
var treecko = ["Absorb"]
var bulbasaur = ["Absorb"]
var chikorita = ["Absorb"]
#Fire
var torchic = ["Ember"]
var charmander = ["Ember"]
var cyndaquil = ["Ember"]
#Normal
var zigzagoon = ["Bite"]
#Mons
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
func RandMov(mon):
	var value = pkmn[mon]
	var arrlen = value.size()
	var rand = randi_range(0,arrlen - 1)
	var output = value[rand]
	Mov_return.emit(output)
	
