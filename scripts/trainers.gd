extends Control
signal get_pkmn_data(name)
signal text(text)
signal send_party(party)
var data : Array
var stats
var party
@onready var trainer = get_parent().get_node("Move_layer/trainer")
@onready var Enemypos = get_parent().get_node("Cast/Enemy/Enemy_sprite")
func IVify(level):
	var dict = {
		"level": randi_range(5,7),
		"atk": randi_range(5,6),
		"def": randi_range(5,6),
		"spd": randi_range(5,6),
		"hp": randi_range(5,6),
	}
	return dict
func Trainer_battle(index):
	match index:
		1:
			var base_ivs1 = IVify(1)
			var base_ivs2 = IVify(1)
			data.clear()
			get_pkmn_data.emit("mudkip")
			stats = data[2]
			var mon1 = {
				"type": data[0],
				"type2": data[1],
				"atk": stats.atk + base_ivs1.atk,
				"def": stats.def + base_ivs1.def,
				"spd": stats.spd + base_ivs1.spd,
				"hp": stats.hp + base_ivs1.hp,
				"level": base_ivs1.level,
				"name": "mudkip"
			}
			data.clear()
			get_pkmn_data.emit("zigzagoon")
			stats = data[2]
			var mon2 = {
				"type": data[0],
				"type2": data[1],
				"atk": stats.atk + base_ivs2.atk,
				"def": stats.def + base_ivs2.def,
				"spd": stats.spd + base_ivs2.spd,
				"hp": stats.hp + base_ivs2.hp,
				"level": base_ivs2.level,
				"name": "zigzagoon"
			}
			party = {
				"first": mon1,
				"second": mon2,
				"third": null,
				"forth": null,
				"fifth": null,
				"sixth": null,
				"sprite": "may",
				"text": "Hey there lets battle!",
			}
	trainer.position = Enemypos.global_position
	trainer.position.x += 230
	var output = trainer.position.x + 400
	trainer.texture = load("res://assets/trainers/"+party.sprite+".png")
	trainer.show()
	text.emit(party.text)
	await get_tree().create_timer(1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(trainer,"position",Vector2(output,trainer.position.y),1)
	await get_tree().create_timer(1).timeout
	send_party.emit(party)


func Return_data(type,type2,stats):
	data.append(type)
	data.append(type2)
	data.append(stats)
