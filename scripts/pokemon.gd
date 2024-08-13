extends Control
class_name pokemon
signal pkmn_data()
signal return_mon_data()
signal random_pokemon()
func create_pokemon(type, type2, catch_rate, base_stats, ability):
	return {
		"type": type,
		"type2": type2,
		"catch": catch_rate,
		"base_stats": base_stats,
		"ability": ability
	}
var pkmn = {
	"totodile": create_pokemon("Water", "none", 45, {"hp": 50, "atk": 65, "def": 64, "spd": 43}, "Torrent"),
	"bulbasaur": create_pokemon("Grass", "Poison", 45, {"hp": 45, "atk": 49, "def": 49, "spd": 45}, "Overgrow"),
	"charmander": create_pokemon("Fire", "none", 45, {"hp": 39, "atk": 52, "def": 43, "spd": 65}, "Blaze"),
	"squirtle": create_pokemon("Water", "none", 45, {"hp": 44, "atk": 48, "def": 65, "spd": 43}, "Torrent"),
	"cyndaquil": create_pokemon("Fire", "none", 45, {"hp": 39, "atk": 52, "def": 43, "spd": 65}, "Blaze"),
	"chikorita": create_pokemon("Grass", "none", 45, {"hp": 45, "atk": 49, "def": 65, "spd": 45}, "Overgrow"),
	"zigzagoon": create_pokemon("Normal", "none", 255, {"hp": 38, "atk": 30, "def": 41, "spd": 60}, "Pickup"),
	"mudkip": create_pokemon("Water", "none", 45, {"hp": 50, "atk": 70, "def": 50, "spd": 40}, "Torrent"),
	"torchic": create_pokemon("Fire", "none", 45, {"hp": 45, "atk": 60, "def": 40, "spd": 45}, "Blaze"),
	"treecko": create_pokemon("Grass", "none", 45, {"hp": 40, "atk": 45, "def": 35, "spd": 70}, "Overgrow"),
	"ivysaur": create_pokemon("Grass", "Poison", 45, {"hp": 60, "atk": 62, "def": 63, "spd": 60}, "Overgrow"),
	"caterpie": create_pokemon("Bug", "none", 255, {"hp": 45, "atk": 30, "def": 35, "spd": 45}, "Shield Dust"),
	"poochyena": create_pokemon("Dark", "none", 190, {"hp": 35, "atk": 55, "def": 35, "spd": 35}, "Run Away"),
	"lotad": create_pokemon("Water", "Grass", 255, {"hp": 40, "atk": 30, "def": 30, "spd": 30}, "Swift Swim"),
	"seedot": create_pokemon("Grass", "none", 255, {"hp": 40, "atk": 40, "def": 50, "spd": 30}, "Chlorophyll"),
	"taillow": create_pokemon("Normal", "Flying", 200, {"hp": 40, "atk": 55, "def": 30, "spd": 85}, "Guts"),
	"wingull": create_pokemon("Water", "Flying", 255, {"hp": 40, "atk": 30, "def": 30, "spd": 85}, "Keen Eye"),
	"ralts": create_pokemon("Psychic", "Fairy", 235, {"hp": 28, "atk": 25, "def": 25, "spd": 40}, "Synchronize"),
	"surskit": create_pokemon("Bug", "Water", 255, {"hp": 40, "atk": 30, "def": 32, "spd": 50}, "Swift Swim"),
	"shroomish": create_pokemon("Grass", "none", 255, {"hp": 60, "atk": 40, "def": 60, "spd": 35}, "Effect Spore"),
	"jigglypuff": create_pokemon("Normal", "Fairy", 170, {"hp": 115, "atk": 45, "def": 20, "spd": 20}, "Cute Charm"),
	"slakoth": create_pokemon("Normal", "none", 255, {"hp": 60, "atk": 60, "def": 60, "spd": 30}, "Truant"),
	"nincada": create_pokemon("Bug", "Ground", 255, {"hp": 31, "atk": 45, "def": 90, "spd": 40}, "Compoundeyes"),
	"whismur": create_pokemon("Normal", "none", 255, {"hp": 44, "atk": 50, "def": 23, "spd": 44}, "Soundproof"),
	"makuhita": create_pokemon("Steel", "none", 255, {"hp": 70, "atk": 50, "def": 90, "spd": 30}, "Swift Swim"),
	}
var pkmn1 = {
	"zigzagoon": pkmn["zigzagoon"],
	"caterpie": pkmn["caterpie"],
	"poochyena": pkmn["poochyena"],
	"lotad": pkmn["lotad"],
	"seedot": pkmn["seedot"],
	"wingull": pkmn["wingull"],
	"shroomish": pkmn["shroomish"],
	"surskit": pkmn["surskit"],
	"ralts": pkmn["ralts"],
	"taillow": pkmn["taillow"],
	"jigglypuff": pkmn["jigglypuff"],
	"slakoth": pkmn["slakoth"],
	"nincada": pkmn["nincada"],
	"whismur": pkmn["whismur"],
	"makuhita": pkmn["makuhita"],
	}
func _on_main_window_type_requester(pokemoner):
	var data = pkmn.get(pokemoner)
	pkmn_data.emit(data.type,data.type2,data.base_stats,data.ability)
func RandMon(lvl):
	var keys
	var value
	var random_key
	match lvl: 
		1:
			keys = pkmn1.keys()
			random_key = keys[randi() % keys.size()]
			value = pkmn1[random_key]
	random_pokemon.emit(value.type,value.type2,random_key,value.base_stats,value.ability)
func get_pokemon_data(xname):
	var mon = pkmn[xname]
	return_mon_data.emit(mon.type,mon.type2,mon.base_stats,mon.ability)
func evodata(xname,old_name):
	var mon = pkmn[xname]
	var old = pkmn[old_name]
	return [mon.base_stats,mon.ability,old.base_stats]
