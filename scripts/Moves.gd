extends Control
signal text(text)
signal damage(entity,damage,text)
signal effects(entity,effect)



func _on_main_window_attack(Move, Entity, Stats, OStats):
	match Move:
		"Slap":
			if Stats.atk /OStats.def / 2 <= 0:
				damage.emit(Entity,1,Entity+" Weakly slapped the Enemy")
			else:
				damage.emit(Entity,Stats.atk /OStats.def / 2,Entity+" Slapped the Enemy")
