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
	"Watergun": create_move(40, 100, "Water", " was sprayed with water!"),
	"Bite": create_move(60, 100, "Dark", " was bit!"),
	"Ember": create_move(40, 100, "Fire", " was burned by embers!"),
	"Absorb": create_move(20, 100, "Grass", " had its health absorbed!"),
	"Tackle": create_move(40, 100, "Normal", " was tackled!"),
	"Thunderbolt": create_move(90, 100, "Electric", " was struck by lightning!"),
	"Flamethrower": create_move(90, 100, "Fire", " was struck by flamethrower!"),
	"Dragon Breath": create_move(60, 100, "Dragon", " was struck by dragon breath!"),
	"Thunder": create_move(110, 70, "Electric", " was struck by thunder!"),
	"Earthquake": create_move(100, 100, "Ground", " was hit by earthquake!"),
	"Rock Throw": create_move(50, 90, "Rock", " was thrown with rocks!"),
	"Rock Slide": create_move(75, 90, "Rock", " was hit by rock slide!"),
	"Dragon Tail": create_move(60, 90, "Dragon", " was struck by dragon tail!"),
	"Fire Punch": create_move(75, 100, "Fire", " was hit by fire punch!"),
	"Thunder Punch": create_move(75, 100, "Electric", " was hit by thunder punch!"),
	"Water Pulse": create_move(60, 100, "Water", " was hit by water pulse!"),
	"Crunch": create_move(80, 100, "Dark", " was hit by crunch!"),
	"Shadow Ball": create_move(80, 100, "Ghost", " was hit by shadow ball!"),
	"Dragon Claw": create_move(80, 100, "Dragon", " was hit by dragon claw!"),
}