extends Control


func Item(item: Variant,who: String) -> void:
	match item.item:
		"potion":
			pass
		"super_potion":
			pass
		"hyper_potion":
			pass
		"poke_ball":
			pass
		"oran_berry":
			if item.hp <= item.max_hp / 2: item.hp += 10; if item.hp > item.max_hp: item.hp = item.max_hp
