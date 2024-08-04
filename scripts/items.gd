extends Control
signal animation(item,enemy)
signal potion(item)
func _on_main_window_run_items(item,enemy):
	match item:
		"potion":
			potion.emit(potion)
		"super_potion":
			potion.emit(potion)
		"hyper_potion":
			potion.emit(potion)
		"poke_ball":
			animation.emit(item,enemy)
