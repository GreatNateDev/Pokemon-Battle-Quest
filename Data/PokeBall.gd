extends Control
@export var main : Control
func catch(ball : String):
	match ball:
		"regular":
			try()
func try(ball_modifier):
	var catch_value = (( (3.0 * main.Enemy.max_hp - 2.0 * main.Enemy.hp) * main * ball_modifier ) / (3.0 * max_hp)) * status_modifier
