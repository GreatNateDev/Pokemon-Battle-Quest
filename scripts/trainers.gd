extends Control
signal get_pkmn_data(name)
signal text(text)
signal send_party(party)
var data : Array
var stats
var party
var base_ivs1
var base_ivs2
var base_ivs3
var base_ivs4
var base_ivs5
var base_ivs6
var mon1
var mon2
var mon3
var mon4
var mon5
var mon6
var dict
@onready var trainer = get_parent().get_node("Move_layer/trainer")
@onready var Enemypos = get_parent().get_node("Cast/Enemy/Enemy_sprite")
func IVify(level):
	match level:
		1:
			dict = {
			"level": randi_range(5,7),
			"atk": randi_range(5,6),
			"def": randi_range(5,6),
			"spd": randi_range(5,6),
			"hp": randi_range(5,6),
			}
	return dict
func Return_data(type,type2,statx):
	data.append(type)
	data.append(type2)
	data.append(statx)
func init_trainer(partys):
	trainer.position = Enemypos.global_position
	trainer.position.x += 230
	var output = trainer.position.x + 400
	trainer.texture = load("res://assets/trainers/"+partys.sprite+".png")
	trainer.show()
	text.emit(partys.text)
	await get_tree().create_timer(1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(trainer,"position",Vector2(output,trainer.position.y),1)
	await get_tree().create_timer(1).timeout
	send_party.emit(partys)
func init_ivs(amt,lvl):
	data.clear()
	if amt >= 1:
		base_ivs1 = IVify(lvl)
	if amt >= 2:
		base_ivs2 = IVify(lvl)
	if amt >= 3:
		base_ivs3 = IVify(lvl)
	if amt >= 4:
		base_ivs4 = IVify(lvl)
	if amt >= 5:
		base_ivs5 = IVify(lvl)
	if amt == 6:
		base_ivs6 = IVify(lvl)
func set_party(first,second,third,forth,fifth,sixth,sprite,textx):
				party = {
				"first": first,
				"second": second,
				"third": third,
				"forth": forth,
				"fifth": fifth,
				"sixth": sixth,
				"sprite": sprite,
				"text": textx,
			}
func set_mon(amt,nameme):
	match amt:
		1:
			stats = data[2]
			mon1 = {
				"type": data[0],
				"type2": data[1],
				"atk": stats.atk + base_ivs1.atk,
				"def": stats.def + base_ivs1.def,
				"spd": stats.spd + base_ivs1.spd,
				"hp": stats.hp + base_ivs1.hp,
				"level": base_ivs1.level,
				"name": nameme
			}
		2:
			stats = data[2]
			mon2 = {
				"type": data[0],
				"type2": data[1],
				"atk": stats.atk + base_ivs2.atk,
				"def": stats.def + base_ivs2.def,
				"spd": stats.spd + base_ivs2.spd,
				"hp": stats.hp + base_ivs1.hp,
				"level": base_ivs1.level,
				"name": nameme
			}
		3:
			stats = data[2]
			mon3 = {
				"type": data[0],
				"type2": data[1],
				"atk": stats.atk+base_ivs3.atk,
				"def": stats.def + base_ivs3.def,
				"spd": stats.spd + base_ivs3.spd,
				"hp": stats.hp + base_ivs3.hp,
				"level": base_ivs3.level,
				"name": nameme
			}
		4:
			stats = data[2]
			mon4 = {
				"type": data[0],
				"type2": data[1],
				"atk": stats.atk+base_ivs4.atk,
				"def": stats.def + base_ivs4.def,
				"spd": stats.spd + base_ivs4.spd,
				"hp": stats.hp + base_ivs4.hp,
				"level": base_ivs4.level,
				"name": nameme
				}
		5:
			stats = data[2]
			mon5 = {
				"type": data[0],
				"type2": data[1],
				"atk": stats.atk+base_ivs5.atk,
				"def": stats.def + base_ivs5.def,
				"spd": stats.spd + base_ivs5.spd,
				"hp": stats.hp + base_ivs5.hp,
				"level": base_ivs5.level,
				"name": nameme
				}
		6:
			stats = data[2]
			mon6 = {
				"type": data[0],
				"type2": data[1],
				"atk": stats.atk+base_ivs6.atk,
				"def": stats.def + base_ivs6.def,
				"spd": stats.spd + base_ivs6.spd,
				"hp": stats.hp + base_ivs6.hp,
				"level": base_ivs6.level,
				"name": nameme
				}
	data.clear()
func Trainer_battle(index):
	match index:
		1:
			init_ivs(2,1)
			get_pkmn_data.emit("mudkip")
			set_mon(1,"mudkip")
			get_pkmn_data.emit("zigzagoon")
			set_mon(2,"zigzagoon")
			set_party(mon1,mon2,null,null,null,null,"may","Hey there lets battle!")
	init_trainer(party)
