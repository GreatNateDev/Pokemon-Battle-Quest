extends Control
signal damage_rebound(ability_return)
signal damage_text(text)
var went = false
func Damage_abilitys(ability,Stats,Entity,type):
	match ability:
		"Torrent":
			if Stats.hp <= Stats.max_hp / 3 && type == "Water":
				damage(1.5)
		"Blaze":
			if Stats.hp <= Stats.max_hp / 3 && type == "Fire":
				damage(1.5)
		"Overgrow":
			if Stats.hp <= Stats.max_hp / 3 && type == "Grass":
				damage(1.5)
	if went == true:
		damage_text.emit(Entity+"'s "+ability)
		went = false
func damage(num):
	damage_rebound.emit(num)
	went = true
