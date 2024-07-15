extends Control
signal text(text)
signal damage(entity,damage,text)
signal effects(entity,effect)
var opp = null


func _on_main_window_attack(Move, Entity, Stats, OStats):
	var miss = randi_range(1,10)
	if miss == 8:
		pass
	if Entity == "Player":
		opp = "Enemy"
	elif Entity == "Enemy":
		opp = "Player"
	match Move:
		"Slap":
			if Stats.atk /OStats.def / 2 <= 0:
				damage.emit(Entity,1,Entity+" Weakly slapped the "+opp)
			else:
				damage.emit(Entity,Stats.atk /OStats.def / 2,Entity+" Slapped the "+opp)
