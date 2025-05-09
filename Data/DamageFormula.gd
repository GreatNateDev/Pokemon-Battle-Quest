extends Control
#Add crits and STAB
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
	var cat = mov.category
	var type_effectiveness = getMultiplier(mov.type,OStats.type1,OStats.type2)
	var random_number = randi() % 16 + 85
	var base_damage
	if cat == "P":
		base_damage = ((2 * Stats.level / 5 + 2)  * mov.power * Stats.attack / OStats.defense) / 50 + 2
	elif cat == "S":
		base_damage = ((2 * Stats.level / 5 + 2)  * mov.power * Stats.spattack / OStats.spdefense) / 50 + 2
	var adjusted_damage = base_damage * type_effectiveness
	var final_damage = adjusted_damage * random_number / 100
	var txt : String
	if opp == "Player":
		txt = mov.text
		txt = txt.replace("%o", Globals.p_name.capitalize())
		txt = txt.replace("%a", Globals.e_name.capitalize())
	elif opp == "Enemy":
		txt = mov.text
		txt = txt.replace("%o", Globals.e_name.capitalize())
		txt = txt.replace("%a", Globals.p_name.capitalize())
	print(type_effectiveness)
	if type_effectiveness in [2, 4]:  
		txt += ", it was super effective!"
	elif type_effectiveness in [0.5, 0.25]:  
		txt += ", it was not very effective!"
	return [int(final_damage),txt,type_effectiveness]
func getMultiplier(move_type, primary_type, secondary_type):
	var multiplier = 1
	if move_type in Type.typx:
		if primary_type in Type.typx[move_type]:
			multiplier *= Type.typx[move_type][primary_type]
		if secondary_type in Type.typx[move_type]:
			multiplier *= Type.typx[move_type][secondary_type]

	return multiplier
