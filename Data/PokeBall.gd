extends Control
@export var main : Control
@export var ball : Sprite2D
@export var ballshake : AudioStreamPlayer2D
@export var caughtsfx : AudioStreamPlayer2D
@export var fanfair : AudioStreamPlayer2D
@export var Audio : AudioStreamPlayer2D
var final_result
func catch(baller : String):
	match baller:
		"regular":
			final_result = await try(1)
		"master":
			final_result = await try(255)
	return final_result
func try(ball_modifier):
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
		await shake_anim()
		await shake_anim()
		await shake_anim()
		catch_anim()
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
			shake_anim()
			result["shakes"] += 1
		else:
			print("escape!!!")
	
	# If all 4 shakes passed, catch succeeds
	if result["shakes"] == 4:
		result["caught"] = true
	return result
func shake_anim():
	ballshake.play()
	await get_tree().create_tween().tween_property(ball,"skew",-.3,.2).finished
	await get_tree().create_tween().tween_property(ball,"skew",.3,.2).finished
	await get_tree().create_tween().tween_property(ball,"skew",0,.2).finished
	await get_tree().create_timer(.4).timeout
func catch_anim():
	caughtsfx.play()
	ball.self_modulate = Color.DIM_GRAY
	Audio.stop()
	await get_tree().create_timer(.3).timeout
	fanfair.play()
	finish_caught()
	
	
func finish_caught():
	if Globals.mon1 == null:
		Globals.mon1 = main.Enemy
		Globals.mon1.index = 1
	elif Globals.mon2 == null:
		Globals.mon2 = main.Enemy
		Globals.mon2.index = 2
	elif Globals.mon3 == null:
		Globals.mon3 = main.Enemy
		Globals.mon3.index = 3
	elif Globals.mon4 == null:
		Globals.mon4 = main.Enemy
		Globals.mon4.index = 4
	elif Globals.mon5 == null:
		Globals.mon5 = main.Enemy
		Globals.mon5.index = 5
	elif Globals.mon6 == null:
		Globals.mon6 = main.Enemy
		Globals.mon6.index = 6
	else:
		print("fail")
		#replace_mon()
	Globals.BattleID += 1
	main.Player.exp += main.Enemy.level * 12
	if main.Player.exp >= main.Player.max_exp:
			main.Player = main.LevelUpdater.update_level(main.Player)
	main.SaveMon(main.Player)
	main.Save.savefile(main.Player,Globals.money,Globals.starter,Globals.mon1,Globals.mon2,Globals.mon3,Globals.mon4,Globals.mon5,Globals.mon6,Globals.index)
	Globals.loaded = true
	await get_tree().create_timer(7).timeout
	await get_tree().create_tween().tween_property(fanfair,"position",Vector2(3000,0),5).finished
	get_tree().change_scene_to_file("res://scenes/Shop.tscn")
