extends Control
#Signals
signal Mov_return(mov)
#Water
var totodile = ["Watergun","Tackle"]
var mudkip = ["Watergun","Tackle"]
var squirtle = ["Watergun","Tackle"]
#Grass
var treecko = ["Absorb"]
var bulbasaur = ["Absorb","Tackle"]
var chikorita = ["Absorb","Tackle"]
#Fire
var torchic = ["Ember"]
var charmander = ["Ember"]
var cyndaquil = ["Ember","Tackle"]
#Normal
var zigzagoon = ["Bite","Tackle"]
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
	
