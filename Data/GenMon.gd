class_name Gmon
func MonGen(P):
	var file = FileAccess.open("res://Data/Pokemon.json", FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	var Pokemon = {
		name = json[P].name,
		type1= json[P].type1,
		type2 = json[P].type2,
		hp = json[P].stats.Hp,
		attack = json[P].stats.Attack,
		defense = json[P].stats.Defense,
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
		speed = Pokemon.speed,
		moves = Pokemon.moves,
	}
	return mon
