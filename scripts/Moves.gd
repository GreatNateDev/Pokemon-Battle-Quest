extends Control
signal text(text)
signal damage(entity,damage)
signal effects(entity,effect)



func _on_main_window_attack(Move, Entity, Stats, OStats):
	match Move:
		"Slap":
			damage.emit(Entity,Stats.atk /OStats.def / 2)
