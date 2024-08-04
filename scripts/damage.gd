extends Control
@onready var crit = get_parent().get_node("top_layer/CRIT") 
@onready var player = get_parent().get_node("Cast/Player/Player_sprite")
@onready var enemy = get_parent().get_node("Cast/Enemy/Enemy_sprite")
var opp
signal anim(entity,mov)
signal Damage(damage,Entity,text,type_eff)
var Type = types.new()
var Mover = Movos.new()
func Attack(Move, Entity, Stats, OStats):
	if Entity == "Player": opp = "Enemy"
	else : opp = "Player"
	var mov = Mover.movs[Move]
	var type_effectiveness = getMultiplier(mov.type,OStats.type,OStats.type2)
	var stab = 1
	if Stats.type == OStats.type: stab = 1.5
	var crit_chance = 6.25
	if mov.c !=null: crit_chance = 12.5
	var hit_chance = randi() % 100 + 1 
	if hit_chance > mov.accuracy:
		return 0
	var crit_roll = randi() % 100 + 1  # Random number between 1 and 100
	var is_critical = crit_roll <= crit_chance
	var random_number = randi() % 16 + 85
	var base_damage = ((2 * Stats.level / 5 + 2) * Stats.atk * mov.power / OStats.def) / 50 + 2
	var adjusted_damage = base_damage * stab * type_effectiveness
	var final_damage = adjusted_damage * random_number / 100
	if is_critical: 
		final_damage = final_damage * 2
		crito()
	Damage.emit(max(int(final_damage), 1),Entity,opp+mov.text,type_effectiveness)
	anim.emit(Entity,Move)
func getMultiplier(move_type, primary_type, secondary_type):
	var multiplier = 1
	if move_type in Type.typx:
		if primary_type in Type.typx[move_type]:
			multiplier *= Type.typx[move_type][primary_type]
		if secondary_type in Type.typx[move_type]:
			multiplier *= Type.typx[move_type][secondary_type]

	return multiplier

func crito():
	var pos
	if opp == "Player": pos = player.global_position
	else: pos = enemy.global_position
	crit.position = pos
	crit.emitting = true
