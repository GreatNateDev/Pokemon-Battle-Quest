extends Control
signal retux(sprite,type)



func _on_main_window_getrandmon(lvl):
	var mon
	var sprite
	var type
	var type2
	match lvl:
		1:
			mon = randi_range(1,4)
			match mon:
				1:
					sprite = "zigzagoon"
					type = "Normal"
					type2 = "None"
				2:
					sprite = "mudkip"
					type = "Water"
					type2 = "None"
				3:
					sprite = "torchic"
					type = "Fire"
					type2 = "None"
				4:
					sprite = "treecko"
					type = "Grass"
					type2 = "None"
	retux.emit(sprite,type,type2)
