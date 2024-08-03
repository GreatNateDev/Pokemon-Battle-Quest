extends Control
signal animation(item)
func _on_main_window_run_items(item,enemy):
	match item:
		"potion":
			#run pokemon menu
			#click pokemon
			#handle heals
			pass
		"poke_ball":
			animation.emit(item,enemy)
			#catch_rate
			#handle fail and catch
			pass
