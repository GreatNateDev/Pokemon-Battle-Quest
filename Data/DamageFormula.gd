extends Control
#This will need more work
class_name DamageFormula
var opp
var Type = preload("res://Data/Types.gd").new()
func Attack(Move, Entity, Stats, OStats):
	if Entity == "Player": opp = "Enemy"
	else : opp = "Player"
	var f = FileAccess.open("res://Data/Moves.json", FileAccess.READ)
	var json = JSON.parse_string(f.get_as_text())
	f.close()
	var mov = json[Move]
	var type_effectiveness = getMultiplier(mov.type,OStats.type1,OStats.type2)
	var random_number = randi() % 16 + 85
	var base_damage = ((2 * Stats.level / 5 + 2)  * mov.power / OStats.defense) / 50 + 2
	var adjusted_damage = base_damage * type_effectiveness
	var final_damage = adjusted_damage * random_number / 100
	var txt
	if opp == "Player":
		txt = mov.PTEXT
	elif opp == "Enemy":
		txt = mov.ETEXT
	if mov.name == "Tackle":
		final_damage *= 100
	return [int(final_damage),txt]
func getMultiplier(move_type, primary_type, secondary_type):
	var multiplier = 1
	if move_type in Type.typx:
		if primary_type in Type.typx[move_type]:
			multiplier *= Type.typx[move_type][primary_type]
		if secondary_type in Type.typx[move_type]:
			multiplier *= Type.typx[move_type][secondary_type]

	return multiplier
