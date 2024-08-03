extends Control 
var save_path = "user://save/"
var save_name = "Data.tres"
var data = savedata.new()
var Type = types.new()
signal faint(entity)
signal run_items(item)
signal Attack(Move,Entity,Stats,OStats)
signal getrandmon(lvl)
signal type_requester(pokemon)
func load_data():
	data = ResourceLoader.load(save_path+save_name).duplicate(true)
func save_data():
	ResourceSaver.save(data,save_path+save_name)
func _ready():
	if Globals.loader == false and Globals.back_shop == false:
		data.starter = Globals.starter 
		$Cast/Player/Player_sprite.texture = load("res://assets/pokemon/"+str(data.starter)+"/back.png")
		randomize_player()
		random_enemy_level_one()
		set_sprite()
		set_max_exp()
		reset_bars()
		cap_bars()
		set_types()
		set_levels("both")
		init_money()
	elif Globals.loader == true and Globals.back_shop == false:
		verify(save_name)
		load_data()
		$Cast/Player/Player_sprite.texture = load("res://assets/pokemon/"+str(data.starter)+"/back.png")
		data.starter = Globals.starter
		random_enemy_level_one()
		set_sprite()
		set_max_exp()
		reset_bars()
		cap_bars()
		set_types()
		set_levels("both")
		init_money()
	if Globals.back_shop == true and Globals.loader == false:
		Globals.back_shop = false
		verify(save_path)
		load_data()
		if Globals.item != null:
			if data.Items.has(Globals.item) == false:
				data.Items[Globals.item] = 1
			else:
				data.Items[Globals.item] += 1
			Globals.item = null
		if Globals.money != null:
			data.Money = Globals.money
			Globals.money = null
		set_levels("both")
		set_types()
		init_money()
		$Cast/Player/Player_sprite.texture = load("res://assets/pokemon/"+str(data.starter)+"/back.png")
		random_enemy_level_one()
		set_sprite()
		reset_bars()
		cap_bars()
func verify(path):
	DirAccess.make_dir_absolute(path)
func refine_level_stats(entity,lvlup,starting):
	if lvlup == true:
		var old_hp = entity.hp
		var old_spd = entity.spd
		var old_atk = entity.atk
		var old_def = entity.def
		entity.hp += 2
		entity.spd += 2
		entity.atk += 2
		entity.def += 2
		textedit("You leveled up! here are you're old VS new stat HP "+str(old_hp)+" > "+str(entity.hp)+"\nSPEED "+str(old_spd)+" > "+str(entity.spd)+"\nATTACK "+str(old_atk)+" > "+str(entity.atk)+"\nDEFENSE "+str(old_def)+" > "+str(entity.def))
	if starting == true:
		var value = entity.level * 2
		entity.hp += value
		entity.spd += value
		entity.atk += value
		entity.def += value
func set_types():
	$Cast/Player/type.text = data.Player.type
	$Cast/Enemy/type.text = data.Enemy.type
func randomize_player():
	data.Player = {
		"level" : randi_range(5,7),
		"hp" : randi_range(1,5),
		"spd" : randi_range(1,5),
		"atk" : randi_range(1,5),
		"def" : randi_range(1,5),
		"type": request_type(data.starter),
		"exp": 0,
		"max_exp": null,
		"faint": false
	}
	refine_level_stats(data.Player,false,true)
	data.Player1 = data.Player
func random_enemy_level_one():
	var hp = randi_range(1,5)
	data.Enemy = {
		"level" : randi_range(5,7),
		"hp" : hp,
		"spd" : randi_range(1,5),
		"atk" : randi_range(1,5),
		"def" : randi_range(1,5),
		"move1": randmov(),
		"move2": randmov(),
		"move3": randmov(),
		"move4": randmov(),
		"current": null,
		"sprite" : get_random_mon(1),
		"type": set_enemy_type(),
		"max_hp": null,
		"stat": 1,
		"exp": 0,
		"max_exp": null,
		"faint": false
	}
	refine_level_stats(data.Enemy,false,true)
	data.Enemy.max_hp = data.Enemy.hp
func reset_bars():
	$Cast/Player/hpbar.value = data.Player.hp
	$Cast/Enemy/hpbar.value = data.Enemy.hp
	$Cast/Player/xpbar.value = data.Player.exp
func cap_bars():
	$Cast/Player/hpbar.max_value = data.Player.hp
	$Cast/Enemy/hpbar.max_value = data.Enemy.hp
	$Cast/Player/xpbar.max_value = data.Player.max_exp
func disable_btns(value):
	$Cast/Buttons/Fight.disabled = value
	$Cast/Buttons/Run.disabled = value
	$Cast/Buttons/Bag.disabled = value
	$Cast/Buttons/Swap.disabled = value
func Move1():
	Attack.emit($Castless/Box_and_buttons_centre/Move1.text,"Player",data.Player,data.Enemy)
	$Cast/darken.hide()
	$Castless/Box_and_buttons_centre.hide()
func _on_fight_pressed():
	$Cast/darken.show()
	$Castless/Box_and_buttons_centre.show()
	disable_btns(true)
func textedit(text):
	var tween = get_tree().create_tween()
	tween.tween_property($Cast/textbox/Label,"text",text,.3)
func _on_moves_damage(entity, damage, text, type):
	await get_tree().create_timer(.5).timeout
	var multi
	if entity == "Enemy":
		multi = getMultiplier(type,data.Player.type)
		data.Player.hp -= damage * multi
		playsound(multi)
		disable_btns(false)
		var tween = get_tree().create_tween()
		tween.tween_property($Cast/Player/hpbar,"value",data.Player.hp,1).set_trans(Tween.TRANS_LINEAR)
		if data.Player.hp <= $Cast/Player/hpbar.min_value:
			kill_player(data.Player)
			return
	elif entity == "Player":
		multi = getMultiplier(type,data.Enemy.type)
		data.Enemy.hp -= damage * multi
		playsound(multi)
		var tween = get_tree().create_tween()
		tween.tween_property($Cast/Enemy/hpbar,"value",data.Enemy.hp,1).set_trans(Tween.TRANS_LINEAR)
		if data.Enemy.hp <= 0:
			textedit(text)
			await get_tree().create_timer(1).timeout
			kill_enemy()
			return
		$"Timers/after_attack cooldown".start()
	if multi == .5:
		textedit(text+". It was not very effective")
	elif multi == 1:
		textedit(text+". It was effective")
	elif multi == 2 or 4:
		textedit(text+". It was Super Effective")
	else:
		textedit(text)
func Enemy_atk():
	var pick = randi_range(1,4)
	if pick == 1:
		data.Enemy.current = data.Enemy.move1
	elif pick == 2:
		data.Enemy.current = data.Enemy.move2
	elif pick == 3:
		data.Enemy.current = data.Enemy.move3
	elif pick == 4:
		data.Enemy.current = data.Enemy.move4
	Attack.emit(data.Enemy.current,"Enemy",data.Enemy,data.Player)
func _on_after_attack_cooldown_timeout():
	Enemy_atk()
func randmov():
	var movs = randi_range(1,4)
	match movs:
		1:
			return "Ember"
		2:
			return "Absorb"
		3:
			return "Watergun"
		4:
			return "Bite"
func text_from_moves(text,unblocked,entity):
	textedit(text)
	if unblocked == true and entity == "Enemy":
		disable_btns(false)
	if entity == "Player":
		$"Timers/after_attack cooldown".start()
func run_clicked():
	var run_chance = randi_range(1,2)
	if run_chance == 1:
		textedit("You ran away!")
		await get_tree().create_timer(2).timeout
		random_enemy_level_one()
		reset_bars()
		cap_bars()
		textedit("You encountered another enemy! and healed up!")
	elif run_chance == 2:
		textedit("You failed to run away!")
		disable_btns(true)
		await get_tree().create_timer(2).timeout
		Enemy_atk()
func set_levels(entity):
	match entity:
		"Player":
			$Cast/Player/lvl.text = "Level: "+str(data.Player.level)
		"Enemy":
			$Cast/Enemy/lvl.text = "Level: "+str(data.Enemy.level)
		"both":
			$Cast/Player/lvl.text = "Level: "+str(data.Player.level)
			$Cast/Enemy/lvl.text = "Level: "+str(data.Enemy.level)
func Move2():
	Attack.emit($Castless/Box_and_buttons_centre/Move2.text,"Player",data.Player,data.Enemy)
	$Cast/darken.hide()
	$Castless/Box_and_buttons_centre.hide()
func kill_enemy():
	$SFX/faint.play()
	faint.emit("Enemy")
	add_exp(data.Enemy.level * 10)
	data.players_turn = true
	save_data()
	data.Enemy = {}
	await get_tree().create_timer(2).timeout
	await shop()
func add_exp(amt):
	data.Player.exp += amt
	var tween = get_tree().create_tween()
	tween.tween_property($Cast/Player/xpbar,"value",data.Player.exp,1)
	if data.Player.exp >= data.Player.max_exp:
		level_up()
func level_up():
	$SFX/lvlup.play()
	await get_tree().create_timer(1).timeout
	data.Player.exp = 0
	data.Player.level += 1
	refine_level_stats(data.Player,true,false)
	set_max_exp()
	set_levels("Player")
	$Cast/Player/xpbar.value = 0
func set_max_exp():
	data.Player.max_exp = data.Player.level * 30
	$Cast/Player/xpbar.max_value = data.Player.max_exp
func Move3():
	Attack.emit($Castless/Box_and_buttons_centre/Move3.text,"Player",data.Player,data.Enemy)
	$Cast/darken.hide()
	$Castless/Box_and_buttons_centre.hide()
func Move4():
	Attack.emit($Castless/Box_and_buttons_centre/Move4.text,"Player",data.Player,data.Enemy)
	$Cast/darken.hide()
	$Castless/Box_and_buttons_centre.hide()
func get_random_mon(lvl):
	getrandmon.emit(lvl)
func retux_mon(sprite, type):
	Globals.sprite = sprite 
	$Cast/Enemy/Enemy_sprite.texture = load("res://assets/pokemon/"+sprite+"/front.png")
	Globals.Enemy_type = type
func request_type(pkmn):
	type_requester.emit(pkmn)
	var dato = Globals.loaded_data
	Globals.loaded_data = null
	return dato
func pokemon_data(pkmn):
	Globals.loaded_data = pkmn
func set_enemy_type():
	var type = Globals.Enemy_type
	Globals.Enemy_type = null
	return type
func init_money():
	$Cast/Money/Money_label.text = str(data.Money)+"$"
func getMultiplier(Move_type,Entity_type):
	if Move_type in Type.typx and Entity_type in Type.typx[Move_type]:
		return Type.typx[Move_type][Entity_type]
	else:
		return 1
func kill_player(plr):
	$SFX/faint.play()
	faint.emit("Player")
	data.players_turn = true
	disable_btns(true)
	plr.faint = true
	#switch mon
	if data.Player.faint == true:
		await get_tree().create_timer(.5).timeout
		DirAccess.remove_absolute(save_path+save_name)
		get_tree().change_scene_to_file("res://scenes/pkmn choice.tscn")
func _input(event):
	if OS.is_debug_build():
		if event.is_action_pressed("ui_accept"):
			save_data()
			print(data.Enemy)
			print("Player hp: "+str(data.Player.hp)+" Player def: "+str(data.Player.def)+" Player atk: "+str(data.Player.atk)+" Player spd: "+str(data.Player.spd)+"\nEnemy hp: "+str(data.Enemy.hp)+" Enemy atk: "+str(data.Enemy.atk)+" Enemy def: "+str(data.Enemy.def)+" Enemy spd: "+str(data.Enemy.spd))
			shop()
			#_on_moves_damage("Player",1000,"E","Water")
			pass
func playsound(multiplyer):
	match multiplyer:
		2:
			$"SFX/super attack".play()
		4:
			$"SFX/super attack".play()
		1:
			$SFX/attack.play()
		0.5:
			$"SFX/weak attack".play()
func Bag():
	$Cast/darken.show()
	$Castless/Bag.show()
	disable_btns(true)
	update_bag()
func update_bag():
	for child in $Castless/Bag/Container.get_children():
		child.queue_free()
	for key in data.Items.keys():
		var new_button : TextureButton = TextureButton.new()
		var new_text : Label = Label.new()
		$Castless/Bag/Container.add_child(new_button)
		new_button.add_child(new_text)
		new_text.position = new_button.position
		new_text.position.y += 30
		new_text.text = str(data.Items[key])
		new_button.add_to_group("ItemButton")
		new_button.texture_normal = load("res://assets/items/"+str(key)+".png")
		new_button.pressed.connect(Item_pressed.bind(key))
func Item_pressed(key):
	data.Items[key] -= 1
	if data.Items[key] == 0:
		var texture_to_check = "res://assets/items/"+key+".png"
		for button in get_tree().get_nodes_in_group("ItemButton"):
			if button.texture_normal.resource_path == texture_to_check:
				button.queue_free()
		data.Items.erase(key)
	$Cast/darken.hide()
	$Castless/Bag.hide()
	disable_btns(false)
	run_items.emit(key,data.Enemy)
func shop():
	Globals.money = data.Money
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
func set_sprite():
	data.Enemy.sprite = Globals.sprite
