extends Control
signal animation(item)
func _on_main_window_run_items(item):
	match item:
		"potion":
			#run pokemon menu
			#click pokemon
			#handle heals
			pass
		"poke_ball":
			animation.emit(item)
			#catch_rate
			#handle fail and catch
			pass
