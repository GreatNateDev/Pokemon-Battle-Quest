class_name levelupdater
func update_level(Entity : Dictionary) -> Dictionary:
	Entity.max_exp = Entity.level * 100
	Entity.exp = 0
	var stats = FileAccess.open("res://Data/Pokemon.json", FileAccess.READ)
	stats = JSON.parse_string(stats.get_as_text())
	stats = stats[Entity.name].stats
	Entity.hp = stats.Hp
	Entity.attack = stats.Attack
	Entity.defense = stats.Defense
	Entity.spattack = stats.SpAttack
	Entity.spdefense = stats.SpDefense
	Entity.speed = stats.Speed
	Entity.hp += Entity.IVS.hp
	Entity.attack += Entity.IVS.attack
	Entity.defense += Entity.IVS.defense
	Entity.spattack += Entity.IVS.spattack
	Entity.spdefense += Entity.IVS.spdefense
	Entity.speed += Entity.IVS.speed
	Entity.hp += Entity.EVS.hp
	Entity.attack += Entity.EVS.attack
	Entity.defense += Entity.EVS.defense
	Entity.spattack += Entity.EVS.spattack
	Entity.spdefense += Entity.EVS.spdefense
	Entity.speed += Entity.EVS.speed
	if Entity.has("max_hp"):
		Entity.max_hp = Entity.hp
	return Entity
