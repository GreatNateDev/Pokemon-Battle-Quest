extends Control
class_name DamageFormula
var opp
#FIX SPACES
func Attack(Move, Entity, Stats, OStats):
	if Entity == "Player": opp = "Enemy"
	else : opp = "Player"
	var f = FileAccess.open("res://Data/Moves.json", FileAccess.READ)
	var json = JSON.parse_string(f.get_as_text())
	f.close()
	var mov = json[Move]
	print(mov)
	#var type_effectiveness = getMultiplier(mov.type,OStats.type,OStats.type2)
	var hit_chance = randi() % 100 + 1 
	var damager
	if hit_chance > mov.accuracy:
		return 0
	if mov.catagory == "Physical":
		damager = Stats.atk
	if mov.catagory == "Special":
		damager = Stats.spatk
	var random_number = randi() % 16 + 85
	var base_damage = ((2 * Stats.level / 5 + 2) * damager * mov.power / OStats.def) / 50 + 2
	var adjusted_damage = base_damage #* stab #* type_effectiveness
	var final_damage = adjusted_damage * random_number / 100
	#return damage
#func getMultiplier(move_type, primary_type, secondary_type):
	#var multiplier = 1
	#if move_type in Type.typx:
	#	if primary_type in Type.typx[move_type]:
	#		multiplier *= Type.typx[move_type][primary_type]
	#	if secondary_type in Type.typx[move_type]:
		#	multiplier *= Type.typx[move_type][secondary_type]

	#return multiplier