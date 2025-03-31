extends Control
@export var main : Control
@export var ball : Sprite2D
var final_result
func catch(baller : String):
	match baller:
		"regular":
			final_result = await try(1)
	return final_result
func try(ball_modifier):
	print(main.Enemy)
	var catch_value = (( (3.0 * main.Enemy.max_hp - 2.0 * main.Enemy.hp) * main.Enemy.catch_rate * ball_modifier ) / (3.0 * main.Enemy.max_hp)) * main.Enemy.status_mod
	var final = await calculate_shakes(catch_value)
	if final["caught"] == true:
		return true
func calculate_shakes(catch_value: float) -> Dictionary:
	var result = {"caught": false, "shakes": 0}
	
	# Catch is GUARANTEED if catch_value >= 255 (e.g., Master Ball)
	if catch_value >= 255.0:
		result["caught"] = true
		result["shakes"] = 4
		return result
	
	# Gen III "shake threshold" formula
	var shake_threshold = floor(65536.0 * pow(catch_value / 255.0, 0.25))
	shake_threshold = clamp(shake_threshold, 0, 65535)
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	# Check 4 "shakes"
	for i in 4:
		var rand_val = rng.randi() % 65536  # Random 0-65535
		if rand_val < shake_threshold:
			await shake_anim()
			print("shaked")
			result["shakes"] += 1
		else:
			break  # Break out early if a check fails
	
	# If all 4 shakes passed, catch succeeds
	if result["shakes"] == 4:
		result["caught"] = true
	return result
func shake_anim():
	await get_tree().create_tween().tween_property(ball,"skew",-1,.5).finished
	await get_tree().create_tween().tween_property(ball,"skew",1,.5).finished
	await get_tree().create_tween().tween_property(ball,"skew",0,.5).finished
