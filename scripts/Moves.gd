extends Control
class_name Movos
func create_move(power, accuracy, move_type, text, status, c, catagory):
	return {
		"power": power,
		"accuracy": accuracy,
		"type": move_type,
		"text": text,
		"status": status,
		"c": c,
		"catagory": catagory, 
	}
var movs = {
	"Watergun": create_move(40, 100, "Water", " was sprayed with water!",false,null,"Special"),
	"Bite": create_move(60, 100, "Dark", " was bit!",false,null,"Physical"),
	"Ember": create_move(40, 100, "Fire", " was burned by embers!",false,null,"Special"),
	"Absorb": create_move(20, 100, "Grass", " had its health absorbed!",false,null,"Special"),
	"Tackle": create_move(40, 100, "Normal", " was tackled!",false,null,"Physical"),
	"Vinewhip": create_move(45, 100, "Grass", " was whiped with vine!",false,null,"Physical"),
	"Thunderbolt": create_move(90, 100, "Electric", " was struck by lightning!",false,null,"Special"),
	"Thunder": create_move(110, 70, "Electric", " was struck by lightning!",false,null,"Special"),
	"Rockthrow": create_move(50, 90, "Rock", " was thrown!",false,null,"Physical"),
}
