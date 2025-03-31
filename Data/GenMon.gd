class_name Gmon
func MonGen(P, isPlayer, isTrainer):
	var file = FileAccess.open("res://Data/Pokemon.json", FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	var Pokemon = {
		name = json[P].name,
		type1= json[P].type1,
		type2 = json[P].type2,
		hp = json[P].stats.Hp,
		attack = json[P].stats.Attack,
		defense = json[P].stats.Defense,
		spdefense = json[P].stats.SpDefense,
		spattack = json[P].stats.SpAttack,
		speed = json[P].stats.Speed,
		moves = json[P].moves,
	}
	var mon = {
		name = Pokemon.name,
		type1 = Pokemon.type1,
		type2 = Pokemon.type2,
		level = randi_range(1,5),
		hp = Pokemon.hp,
		attack = Pokemon.attack,
		defense = Pokemon.defense,
		spattack = Pokemon.spattack,
		spdefense = Pokemon.spdefense,
		speed = Pokemon.speed,
		moves = Pokemon.moves,
		IVS = {
			hp = randi_range(1,31),
			attack = randi_range(1,31),
			defense = randi_range(1,31),
			spattack = randi_range(1,31),
			spdefense = randi_range(1,31),
			speed = randi_range(1,31)
		},
		EVS = {
			hp = 1,
			attack = 1,
			defense = 1,
			spattack = 1,
			spdefense = 1,
			speed = 1
		}
	}
	mon["exp"] = 0
	mon["max_exp"] = mon.level * 100
	mon["catch_rate"] = json[P].catch
	mon["status_mod"] = 1
	if isPlayer == true:
		if Globals.mon1 == null:
			mon["index"] = 1
			Globals.mon1 = mon
		elif Globals.mon2 == null:
			mon["index"] = 2
			Globals.mon2 = mon
		elif Globals.mon3 == null:
			mon["index"] = 3
			Globals.mon3 = mon
		elif Globals.mon4 == null:
			mon["index"] = 4
			Globals.mon4 = mon
		elif Globals.mon5 == null:
			mon["index"] = 5
			Globals.mon5 = mon
		elif Globals.mon6 == null:
			mon["index"] = 6
			Globals.mon6 = mon
		mon["max_hp"] = mon.hp
	if isTrainer != 0:
		mon["index"] = isTrainer
	return mon
