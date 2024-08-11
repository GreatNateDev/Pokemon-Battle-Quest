extends Control
signal damage_rebound(ability_return)
signal damage_text(text)
var went = false
func Damage_abilitys(ability,Stats,Entity,type):
	match ability:
		"Torrent":
			if Stats.hp <= Stats.max_hp / 3 && type == "Water":
				damage_rebound.emit(1.5)
				went = true
		"Blaze":
			if Stats.hp <= Stats.max_hp / 3 && type == "Fire":
				damage_rebound.emit(1.5)
				went = true
		"Overgrow":
			if Stats.hp <= Stats.max_hp / 3 && type == "Grass":
				damage_rebound.emit(1.5)
				went = true
	if went == true:
		damage_text.emit(Entity+"'s "+ability)
		went = false
