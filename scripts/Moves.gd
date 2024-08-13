extends Control
class_name Movos
func create_move(power, accuracy, move_type, text, status, c):
	return {
		"power": power,
		"accuracy": accuracy,
		"type": move_type,
		"text": text,
		"status": status,
		"c": c
	}
var movs = {
	"Watergun": create_move(40, 100, "Water", " was sprayed with water!",false,null),
	"Bite": create_move(60, 100, "Dark", " was bit!",false,null),
	"Ember": create_move(40, 100, "Fire", " was burned by embers!",false,null),
	"Absorb": create_move(20, 100, "Grass", " had its health absorbed!",false,null),
	"Tackle": create_move(40, 100, "Normal", " was tackled!",false,null),
}
