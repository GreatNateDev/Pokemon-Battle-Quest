extends Control
signal loseitem(who)
signal item_return(who,effect,num)
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
			loseitem.emit(who)
			item_return.emit(who,"hp",item.hp)
