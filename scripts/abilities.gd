extends Control
signal damage_rebound(ability_return)
func Damage_abilitys(ability,Stats):
	match ability:
		"Torrent":
			if Stats.hp <= Stats.max_hp / 3:
				damage_rebound.emit(1.5)
		"Blaze":
			if Stats.hp <= Stats.max_hp / 3:
				damage_rebound.emit(1.5)
		"Overgrow":
			if Stats.hp <= Stats.max_hp / 3:
				damage_rebound.emit(1.5)
				
