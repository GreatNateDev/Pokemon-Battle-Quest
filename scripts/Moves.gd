extends Control
class_name Movos
func create_move(power, accuracy, move_type, text):
	return {
		"power": power,
		"accuracy": accuracy,
		"c": null,
		"type": move_type,
		"text": text
	}
var movs = {
	"Watergun": create_move(40, 100, "Water", " sprayed with water!"),
	"Bite": create_move(60, 100, "Dark", " was bit!"),
	"Ember": create_move(40, 100, "Fire", " was burned by embers!"),
	"Absorb": create_move(20, 100, "Grass", " had its health absorbed!"),
	"Tackle": create_move(40, 100, "Normal", " was tackled!")
	}
