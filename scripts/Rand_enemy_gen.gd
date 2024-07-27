extends Control
signal retux(sprite,type)



func _on_main_window_getrandmon(lvl):
	var mon
	var sprite
	var type
	match lvl:
		1:
			mon = randi_range(1,4)
			match mon:
				1:
					sprite = "zigzagoon"
					type = "Normal"
				2:
					sprite = "mudkip"
					type = "Water"
				3:
					sprite = "torchic"
					type = "Fire"
				4:
					sprite = "treecko"
					type = "Grass"
	retux.emit(sprite,type)
