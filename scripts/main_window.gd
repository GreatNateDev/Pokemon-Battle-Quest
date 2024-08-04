extends Control 
var save_path = "user://save/"
var save_name = "Data.tres"
var bst
var data = savedata.new()
var speeddiff
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
		
		next_enemy()
		set_sprite()
		set_max_exp()
		reset_bars()
		cap_bars()
		set_types()
		set_levels("both")
		init_money()
		update_swapper()
		if speeddiff == "Enemy":
			disable_btns(true)
			$"Timers/after_attack cooldown".start()
	elif Globals.loader == true and Globals.back_shop == false:
		verify(save_name)
		load_data()
		$Cast/Player/Player_sprite.texture = load("res://assets/pokemon/"+str(data.starter)+"/back.png")
		data.starter = Globals.starter
		next_enemy()
		set_sprite()
		set_max_exp()
		reset_bars()
		cap_bars()
		set_types()
		set_levels("both")
		init_money()
		update_swapper()
		if speeddiff == "Enemy":
			disable_btns(true)
			$"Timers/after_attack cooldown".start()
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
		next_enemy()
		set_sprite()
		reset_bars()
		cap_bars()
		update_swapper()
		if speeddiff == "Enemy":
			disable_btns(true)
			$"Timers/after_attack cooldown".start()
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
		"index": 1,
		"level" : randi_range(5,7),
		"hp" : randi_range(1,5),
		"spd" : randi_range(1,5),
		"atk" : randi_range(1,5),
		"def" : randi_range(1,5),
		"type": request_type(data.starter),
		"exp": 0,
		"max_exp": null,
		"faint": false,
		"name" : Globals.loaded_name,
		"max_hp": null,
		"type2": request_type2()
	}
	data.Player.hp += bst.hp
	data.Player.spd += bst.spd
	data.Player.def += bst.def
	data.Player.atk += bst.atk
	refine_level_stats(data.Player,false,true)
	data.Player.max_hp = data.Player.hp
	data.Player1 = data.Player
func random_enemy_level_one():
	var hp = randi_range(1,5)
	data.Enemy = {
		"level" : randi_range(5,5),
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
		"type" : set_enemy_type(),
		"max_hp" : null,
		"stat" : 1,
		"exp" : 0,
		"max_exp" : null,
		"faint" : false,
		"prehp" : null,
		"predef" : null,
		"preatk" : null,
		"prespd" : null,
		"type2" : set_enemy_type2()
		
	}
	data.Enemy.prehp = data.Enemy.hp
	data.Enemy.preatk = data.Enemy.atk
	data.Enemy.predef = data.Enemy.def
	data.Enemy.prespd = data.Enemy.spd
	refine_level_stats(data.Enemy,false,true)
	data.Enemy.max_hp = data.Enemy.hp
	if data.Player.spd >= data.Enemy.spd:
		speeddiff = "Player"
	else:
		speeddiff = "Enemy"
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
	$backround_layer/darken.hide()
	$Castless/Box_and_buttons_centre.hide()
func _on_fight_pressed():
	$Cast/darken.show()
	$backround_layer/darken.show()
	$Castless/Box_and_buttons_centre.show()
	disable_btns(true)
func textedit(text):
	var tween = get_tree().create_tween()
	tween.tween_property($Cast/textbox/Label,"text",text,.3)
func Damage(damage, entity, text, multi):
	await get_tree().create_timer(.5).timeout
	if entity == "Enemy":
		playsound(multi)
		data.Player.hp -= damage
		disable_btns(false)
		var tween = get_tree().create_tween()
		tween.tween_property($Cast/Player/hpbar,"value",data.Player.hp,1).set_trans(Tween.TRANS_LINEAR)
		if data.Player.hp <= $Cast/Player/hpbar.min_value:
			kill_player(data.Player)
			return
	elif entity == "Player":
		playsound(multi)
		data.Enemy.hp -= damage
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
		next_enemy()
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
	$backround_layer/darken.hide()
	$Castless/Box_and_buttons_centre.hide()
func kill_enemy():
	$SFX/faint.play()
	data.battle_num += 1
	faint.emit("Enemy")
	add_exp(data.Enemy.level * 10)
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
	$backround_layer/darken.hide()
	$Castless/Box_and_buttons_centre.hide()
func Move4():
	Attack.emit($Castless/Box_and_buttons_centre/Move4.text,"Player",data.Player,data.Enemy)
	$Cast/darken.hide()
	$backround_layer/darken.hide()
	$Castless/Box_and_buttons_centre.hide()
func get_random_mon(lvl):
	getrandmon.emit(lvl)
func retux_mon(sprite, type, type2):
	Globals.sprite = sprite 
	$Cast/Enemy/Enemy_sprite.texture = load("res://assets/pokemon/"+sprite+"/front.png")
	Globals.Enemy_type = type
	Globals.Enemy_type2 = type2
func request_type(pkmn):
	type_requester.emit(pkmn)
	var dato = Globals.loaded_data
	Globals.loaded_data = null
	return dato
func request_type2():
	var dato = Globals.loaded_data_two
	Globals.loaded_data_two = null
	return dato
func pokemon_data(pkmn,mon,type2,base):
	Globals.loaded_data = pkmn
	Globals.loaded_data_two = type2
	Globals.loaded_name = mon
	bst = base
func set_enemy_type():
	var type = Globals.Enemy_type
	Globals.Enemy_type = null
	return type
func set_enemy_type2():
	var type2 = Globals.Enemy_type2
	Globals.Enemy_type2 = null
	return type2
func init_money():
	$Cast/Money/Money_label.text = str(data.Money)+"$"
func kill_player(plr):
	$SFX/faint.play()
	faint.emit("Player")
	disable_btns(true)
	plr.faint = true
	Swap()
func _input(event):
	if OS.is_debug_build():
		if event.is_action_pressed("ui_accept"):
			#save_data()
			#print("Player hp: "+str(data.Player.hp)+" Player def: "+str(data.Player.def)+" Player atk: "+str(data.Player.atk)+" Player spd: "+str(data.Player.spd)+"\nEnemy hp: "+str(data.Enemy.hp)+" Enemy atk: "+str(data.Enemy.atk)+" Enemy def: "+str(data.Enemy.def)+" Enemy spd: "+str(data.Enemy.spd))
			#shop()
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
	$backround_layer/darken.show()
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
	$backround_layer/darken.hide()
	$Castless/Bag.hide()
	disable_btns(false)
	run_items.emit(key,data.Enemy)
func shop():
	Globals.money = data.Money
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
func set_sprite():
	data.Enemy.sprite = Globals.sprite
func Swap():
	$Castless/Pokemon_Menu.show()
	$Cast/darken.show()
	$backround_layer/darken.show()
	disable_btns(true)
	update_swapper()
func update_swapper():
	if data.Player1 != null:
		$Castless/Pokemon_Menu/ItemList.set_item_icon(0,load("res://assets/pokemon/"+data.Player1.name+"/front.png"))
		$Castless/Pokemon_Menu/ItemList.set_item_text(0,data.Player1.name)
	if data.Player2 != null:
		$Castless/Pokemon_Menu/ItemList.set_item_icon(1,load("res://assets/pokemon/"+data.Player2.name+"/front.png"))
		$Castless/Pokemon_Menu/ItemList.set_item_text(1,data.Player2.name)
	if data.Player3 != null:
		$Castless/Pokemon_Menu/ItemList.set_item_icon(2,load("res://assets/pokemon/"+data.Player3.name+"/front.png"))
		$Castless/Pokemon_Menu/ItemList.set_item_text(2,data.Player3.name)
	if data.Player4 != null:
		$Castless/Pokemon_Menu/ItemList.set_item_icon(3,load("res://assets/pokemon/"+data.Player4.name+"/front.png"))
		$Castless/Pokemon_Menu/ItemList.set_item_text(3,data.Player4.name)
	if data.Player5 != null:
		$Castless/Pokemon_Menu/ItemList.set_item_icon(4,load("res://assets/pokemon/"+data.Player5.name+"/front.png"))
		$Castless/Pokemon_Menu/ItemList.set_item_text(4,data.Player5.name)
	if data.Player6 != null:
		$Castless/Pokemon_Menu/ItemList.set_item_icon(5,load("res://assets/pokemon/"+data.Player6.name+"/front.png"))
		$Castless/Pokemon_Menu/ItemList.set_item_text(5,data.Player6.name)
func anim_text(text):
	textedit(text)
func caught():
	Swap()
	Globals.swapvar = "caught"
func Pokemon_swap(index, _at_position, _mouse_button_index):
	match Globals.swapvar:
		null:
			checkfaint()
			var old_index = data.Player.index
			match data.Player.index:
				1:
					data.Player1 = data.Player
				2:
					data.Player2 = data.Player
				3:
					data.Player3 = data.Player
				4:
					data.Player4 = data.Player
				5:
					data.Player5 = data.Player
				6:
					data.Player6 = data.Player
			match index:
				0:
					if data.Player1 != null: if data.Player.index != data.Player1.index and data.Player1.faint == false:
						data.Player = data.Player1
				1:
					if data.Player2 != null: if data.Player.index != data.Player2.index and data.Player2.faint == false:
						data.Player = data.Player2
				2:
					if data.Player3 != null: if data.Player.index != data.Player3.index and data.Player3.faint == false:
						data.Player = data.Player3
				3:
					if data.Player4 != null: if data.Player.index != data.Player4.index and data.Player4.faint == false:
						data.Player = data.Player4
				4:
					if data.Player5 != null: if data.Player.index != data.Player5.index and data.Player5.faint == false:
						data.Player = data.Player5
				5:
					if data.Player6 != null: if data.Player.index != data.Player6.index and data.Player6.faint == false:
						data.Player = data.Player6
			if data.Player.index == old_index:
				$Castless/Pokemon_Menu.hide()
				$Cast/darken.hide()
				$backround_layer/darken.hide()
				disable_btns(false)
				return 1
			$Castless/Pokemon_Menu.hide()
			$Cast/darken.hide()
			$backround_layer/darken.hide()
			update_swapper()
			faint.emit("Player")
			await get_tree().create_timer(3.5).timeout
			set_max_exp()
			$Cast/Player/hpbar.value = data.Player.hp
			$Cast/Player/hpbar.max_value = data.Player.hp
			set_types()
			set_levels("both")
			$Cast/Player/Player_sprite.texture = load("res://assets/pokemon/"+data.Player.name+"/back.png")
			faint.emit("Swap")
			await get_tree().create_timer(3.5).timeout
			textedit("You sent out "+data.Player.name+"!")
			$"Timers/after_attack cooldown".start()
		"caught":
			$Castless/Pokemon_Menu/ItemList.set_item_icon(index,load("res://assets/pokemon/"+data.Enemy.sprite+"/front.png"))
			$Castless/Pokemon_Menu/ItemList.set_item_text(index,data.Enemy.sprite)
			Globals.swapvar = null
			match  index:
				0:
					data.Player1 = {
						"index": 1,
						"hp": data.Enemy.prehp,
						"def": data.Enemy.predef,
						"atk": data.Enemy.preatk,
						"spd": data.Enemy.prespd,
						"level": data.Enemy.level,
						"type2": data.Enemy.type2,
						"exp": 0,
						"max_exp" : null,
						"faint" : false,
						"name": data.Enemy.sprite,
						"max_hp": null,
					}
					refine_level_stats(data.Player1,false,true)
					data.Player1.max_hp = data.Player1.hp
				1:
					data.Player2 = {
						"index": 2,
						"hp": data.Enemy.prehp,
						"def": data.Enemy.predef,
						"atk": data.Enemy.preatk,
						"spd": data.Enemy.prespd,
						"level": data.Enemy.level,
						"type": data.Enemy.type,
						"exp": 0,
						"max_exp" : null,
						"faint" : false,
						"name": data.Enemy.sprite,
						"max_hp": null,
						"type2": data.Enemy.type2,
					}
					refine_level_stats(data.Player2,false,true)
					data.Player2.max_hp = data.Player2.hp
				2:
					data.Player3 = {
						"index": 3,
						"hp": data.Enemy.prehp,
						"def": data.Enemy.predef,
						"atk": data.Enemy.preatk,
						"spd": data.Enemy.prespd,
						"level": data.Enemy.level,
						"type": data.Enemy.type,
						"exp": 0,
						"max_exp" : null,
						"faint" : false,
						"name": data.Enemy.sprite,
						"max_hp": null,
						"type2": data.Enemy.type2,
					}
					refine_level_stats(data.Player3,false,true)
					data.Player3.max_hp = data.Player3.hp
				3:
					data.Player4 = {
						"index": 4,
						"hp": data.Enemy.prehp,
						"def": data.Enemy.predef,
						"atk": data.Enemy.preatk,
						"spd": data.Enemy.prespd,
						"level": data.Enemy.level,
						"type": data.Enemy.type,
						"exp": 0,
						"max_exp" : null,
						"faint" : false,
						"name": data.Enemy.sprite,
						"max_hp": null,
						"type2": data.Enemy.type2,
					}
					refine_level_stats(data.Player4,false,true)
					data.Player4.max_hp = data.Player4.hp
				4:
					data.Player5 = {
						"index": 5,
						"hp": data.Enemy.prehp,
						"def": data.Enemy.predef,
						"atk": data.Enemy.preatk,
						"spd": data.Enemy.prespd,
						"level": data.Enemy.level,
						"type": data.Enemy.type,
						"exp": 0,
						"max_exp" : null,
						"faint" : false,
						"name": data.Enemy.sprite,
						"max_hp": null,
						"type2": data.Enemy.type2,
					}
					refine_level_stats(data.Player5,false,true)
					data.Player5.max_hp = data.Player5.hp
				5:
					data.Player6 = {
						"index": 6,
						"hp": data.Enemy.prehp,
						"def": data.Enemy.predef,
						"atk": data.Enemy.preatk,
						"spd": data.Enemy.prespd,
						"level": data.Enemy.level,
						"type": data.Enemy.type,
						"exp": 0,
						"max_exp" : null,
						"faint" : false,
						"name": data.Enemy.sprite,
						"max_hp": null,
						"type2": data.Enemy.type2,
					}
					refine_level_stats(data.Player6,false,true)
					data.Player6.max_hp = data.Player6.hp
			faint.emit("Enemy")
			data.battle_num += 1
			add_exp(data.Enemy.level * 10)
			save_data()
			data.Enemy = {}
			await get_tree().create_timer(2).timeout
			await shop()
		"potion":
			var heal
			match Globals.swapitem:
				"potion":
					heal = 20
				"super_potion":
					heal = 50
				"hyper_potion":
					heal = 200
			match index:
				0:
					if data.Player1 != null:
						data.Player1.hp += heal
						if data.Player1.hp > data.Player1.max_hp:
							data.Player1.hp = data.Player1.max_hp
						data.Player = data.Player1
				1:
					if data.Player2 != null:
						data.Player2.hp += heal
						if data.Player2.hp > data.Player2.max_hp:
							data.Player2.hp = data.Player2.max_hp
						data.Player = data.Player2
				2:
					if data.Player3 != null:
						data.Player3.hp += heal
						if data.Player3.hp > data.Player3.max_hp:
							data.Player3.hp = data.Player3.max_hp
						data.Player = data.Player3
				3:
					if data.Player4 != null:
						data.Player4.hp += heal
						if data.Player4.hp > data.Player4.max_hp:
							data.Player4.hp = data.Player4.max_hp
						data.Player = data.Player4
				4:
					if data.Player5 != null:
						data.Player5.hp += heal
						if data.Player5.hp > data.Player5.max_hp:
							data.Player5.hp = data.Player5.max_hp
						data.Player = data.Player5
				5:
					if data.Player6 != null:
						data.Player6.hp += heal
						if data.Player6.hp > data.Player6.max_hp:
							data.Player6.hp = data.Player6.max_hp
						data.Player = data.Player6
			update_swapper()
func Potion(item):
	Globals.swapvar = "potion"
	Globals.swapitem = item
func checkfaint():
	var clear1
	var clear2
	var clear3
	var clear4
	var clear5
	var clear6
	if data.Player1 == null: data.Player1 = {"index":1,"faint":true}; clear1=true 
	if data.Player2 == null: data.Player2 = {"index":2,"faint":true}; clear2=true
	if data.Player3 == null: data.Player3 = {"index":3,"faint":true}; clear3=true
	if data.Player4 == null: data.Player4 = {"index":4,"faint":true}; clear4=true
	if data.Player5 == null: data.Player5 = {"index":5,"faint":true}; clear5=true
	if data.Player6 == null: data.Player6 = {"index":6,"faint":true}; clear6=true
	match data.Player.index:
		data.Player1.index:
			data.Player1 = data.Player
		data.Player2.index:
			data.Player2 = data.Player
		data.Player3.index:
			data.Player3 = data.Player
		data.Player4.index:
			data.Player4 = data.Player
		data.Player5.index:
			data.Player1 = data.Player
		data.Player6.index:
			data.Player6 = data.Player
	if data.Player1.faint == true and data.Player2.faint == true and data.Player3.faint == true and data.Player4.faint == true and data.Player5.faint == true and data.Player6.faint == true:
		await get_tree().create_timer(.5).timeout
		DirAccess.remove_absolute(save_path+save_name)
		get_tree().change_scene_to_file("res://scenes/pkmn choice.tscn")
	if clear1:
		data.Player1 = null
	if clear2:
		data.Player2 = null
	if clear3:
		data.Player3 = null
	if clear4:
		data.Player4 = null
	if clear5:
		data.Player5 = null
	if clear6:
		data.Player6 = null
func failed():
	disable_btns(true)
	$"Timers/after_attack cooldown".start()
func next_enemy():
	if data.battle_num < 5:
		random_enemy_level_one()
	else:
		random_enemy_level_one()
