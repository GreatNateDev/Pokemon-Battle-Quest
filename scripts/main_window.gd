extends Control 
var save_path = "user://save/"
var save_name = "Data.tres"
var bst
var left = 0
var data = savedata.new()
var speeddiff
var Trainer_Party
var rand_mon
var catchable = true
var movs : Array
var player_mon : Array
var damage_state = false
signal get_new_move(data)
signal evolve(pokemon,level)
signal trainer_battle(index)
signal faint(entity)
signal run_items(item)
signal Attack(Move,Entity,Stats,OStats)
signal type_requester(pokemon)
signal random_pokemon(mon)
signal randmov()
signal HeldItem(item)
func load_data():
	data = ResourceLoader.load(save_path+save_name).duplicate(true)
func save_data():
	ResourceSaver.save(data,save_path+save_name)
func _ready():
	if Globals.loader == false and Globals.back_shop == false:
		save_data()
		data.starter = Globals.starter 
		$Cast/Player/Player_sprite.texture = load("res://assets/pokemon/"+str(data.starter)+"/back.png")
		randomize_player()
		update_moves()
		next_enemy()
		read_item()
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
		reset_bars()
		cap_bars()
	elif Globals.loader == true and Globals.back_shop == false:
		verify(save_name)
		load_data()
		$Cast/Player/Player_sprite.texture = load("res://assets/pokemon/"+str(data.starter)+"/back.png")
		data.starter = Globals.starter
		update_moves()
		next_enemy()
		read_item()
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
		reset_bars()
		cap_bars()
	if Globals.back_shop == true and Globals.loader == false:
		Globals.back_shop = false
		verify(save_path)
		load_data()
		update_moves()
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
		read_item()
		reset_bars()
		cap_bars()
		update_swapper()
		set_names("P")
		if speeddiff == "Enemy":
			disable_btns(true)
			$"Timers/after_attack cooldown".start()
	refresh_new_move_selection()
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
		var old_spatk = entity.spatk
		var old_spdef = entity.spdef
		entity.hp += 2
		entity.spd += 2
		entity.atk += 2
		entity.def += 2
		entity.spatk += 2
		entity.spdef += 2
		textedit("You leveled up! here are you're old VS new stat HP "+str(old_hp)+" > "+str(entity.hp)+"\nSPEED "+str(old_spd)+" > "+str(entity.spd)+"\nATTACK "+str(old_atk)+" > "+str(entity.atk)+"\nDEFENSE "+str(old_def)+" > "+str(entity.def)+"\nSPECIAL ATTACK"+str(old_spatk)+" > "+str(entity.spatk)+"\nSPECIAL DEFENSE "+str(old_spdef)+" > "+str(entity.spdef))
	if starting == true:
		var value = entity.level * 2
		entity.hp += value
		entity.spd += value
		entity.atk += value
		entity.def += value
		entity.spatk += value
		entity.spdef += value
func set_types():
	if data.Player != {} and data.Player.type2 == "none" and data.Player.type != null and data.Player.type2 != null:
		$Cast/Player/type.text = data.Player.type
	elif data.Player != {} and data.Player.type != null and data.Player.type2 != null:
		$Cast/Player/type.text = data.Player.type+","+data.Player.type2
	if data.Enemy != {} and data.Enemy.type2 == "none" and data.Enemy.type2 != null and data.Enemy.type != null:
		$Cast/Enemy/type.text = data.Enemy.type
	elif data.Enemy != {} and data.Enemy.type2 != null and data.Enemy.type != null:
		$Cast/Enemy/type.text = data.Enemy.type+","+data.Enemy.type2
func randomize_player():
	data.Player = {
		"index": 1,
		"level" : randi_range(500,700),
		"hp": randi_range(1,31),
		"spd" : randi_range(1,31),
		"atk" : randi_range(1,31),
		"def" : randi_range(1,31),
		"spatk": randi_range(1,31),
		"spdef": randi_range(1,31),
		"type": null,
		"exp": 0,
		"max_exp": null,
		"faint": false,
		"name" : data.starter,
		"max_hp": null,
		"type2": null,
		"Move1": null,
		"Move2": null,
		"Move3": null,
		"Move4": null,
		"item": null,
		"status": null,
		"status_value": 0,
		"status_value2": 0,
	}
	type_requester.emit(data.starter)
	data.Player.type = player_mon[0]
	data.Player.type2 = player_mon[1]
	data.Player.ability = player_mon[2]
	data.Player.hp += bst.hp
	data.Player.spd += bst.spd
	data.Player.def += bst.def
	data.Player.atk += bst.atk
	data.Player.spatk += bst.spatk
	data.Player.spdef += bst.spdef
	movs.clear()
	randmov.emit(data.Player.name)
	randmov.emit(data.Player.name)
	randmov.emit(data.Player.name)
	randmov.emit(data.Player.name)
	data.Player.Move1 = movs[0]
	data.Player.Move2 = movs[1]
	data.Player.Move3 = movs[2]
	data.Player.Move4 = movs[3]
	bst = null
	refine_level_stats(data.Player,false,true)
	data.Player.max_hp = data.Player.hp
	data.Player1 = data.Player
	set_names("P")
func random_enemy(lv1:int,lv2:int,monlvl:int):
	data.Enemy = {
		"level" : randi_range(lv1,lv2),
		"hp": randi_range(1,31),
		"spd" : randi_range(1,31),
		"atk" : randi_range(1,31),
		"def" : randi_range(1,31),
		"spatk": randi_range(1,31),
		"spdef": randi_range(1,31),
		"move1": null,
		"move2": null,
		"move3": null,
		"move4": null,
		"current": null,
		"sprite" : null,
		"type" : null,
		"max_hp" : null,
		"stat" : 1,
		"exp" : 0,
		"max_exp" : null,
		"faint" : false,
		"prehp" : null,
		"predef" : null,
		"preatk" : null,
		"prespd" : null,
		"type2" : null,
		"item": null,
		"status": null,
		"status_value": 0,
		"status_value2": 0,
		
	}
	
	data.Enemy.prehp = data.Enemy.hp
	data.Enemy.preatk = data.Enemy.atk
	data.Enemy.predef = data.Enemy.def
	data.Enemy.prespd = data.Enemy.spd
	data.Enemy.prespatk = data.Enemy.spatk
	data.Enemy.prespdef = data.Enemy.spdef
	random_pokemon.emit(monlvl)
	data.Enemy.type = rand_mon[0]
	data.Enemy.type2 = rand_mon[1]
	data.Enemy.sprite = rand_mon[2]
	data.Enemy.hp += rand_mon[3].hp
	data.Enemy.atk += rand_mon[3].atk
	data.Enemy.def += rand_mon[3].def
	data.Enemy.spd += rand_mon[3].spd
	data.Enemy.spatk += rand_mon[3].spatk
	data.Enemy.spdef += rand_mon[3].spdef
	data.Enemy.ability = rand_mon[4]
	$Cast/Enemy/Enemy_sprite.texture = load("res://assets/pokemon/"+data.Enemy.sprite+"/front.png")
	movs.clear()
	randmov.emit(data.Enemy.sprite)
	randmov.emit(data.Enemy.sprite)
	randmov.emit(data.Enemy.sprite)
	randmov.emit(data.Enemy.sprite)
	data.Enemy.move1 = movs[0]
	data.Enemy.move2 = movs[1]
	data.Enemy.move3 = movs[2]
	data.Enemy.move4 = movs[3]
	refine_level_stats(data.Enemy,false,true)
	data.Enemy.max_hp = data.Enemy.hp
	set_names("E")
	if data.Player.spd >= data.Enemy.spd:
		speeddiff = "Player"
	else:
		speeddiff = "Enemy"
func reset_bars():
	if data.Player != {}: $Cast/Player/hpbar.value = data.Player.hp
	if data.Enemy != {} and data.Enemy.hp != null: $Cast/Enemy/hpbar.value = data.Enemy.hp
	if data.Player != {}: $Cast/Player/xpbar.value = data.Player.exp
func cap_bars():
	if data.Player != {}: $Cast/Player/hpbar.max_value = data.Player.hp
	if data.Enemy != {} and data.Enemy.hp != null: $Cast/Enemy/hpbar.max_value = data.Enemy.hp
	if data.Player != {}: $Cast/Player/xpbar.max_value = data.Player.max_exp
func disable_btns(value):
	$Cast/Buttons/Fight.disabled = value
	$Cast/Buttons/Run.disabled = value
	$Cast/Buttons/Bag.disabled = value
	$Cast/Buttons/Swap.disabled = value
func Move1():
	if $Castless/Box_and_buttons_centre/Move1.text == "":$Cast/darken.hide();$backround_layer/darken.hide();$Castless/Box_and_buttons_centre.hide();return
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
	damage_state = true
	$Timers/damage_state_disabler.start()
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
	var moves = [data.Enemy.move1, data.Enemy.move2, data.Enemy.move3, data.Enemy.move4]
	var valid_moves = []
	for move in moves:
		if move != "":
			valid_moves.append(move)
	var pick = randi_range(0, valid_moves.size() - 1)
	data.Enemy.current = valid_moves[pick]
	Attack.emit(data.Enemy.current, "Enemy", data.Enemy, data.Player)
func _on_after_attack_cooldown_timeout():
	Enemy_atk()
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
	if $Castless/Box_and_buttons_centre/Move2.text == "":$Cast/darken.hide();$backround_layer/darken.hide();$Castless/Box_and_buttons_centre.hide();return
	Attack.emit($Castless/Box_and_buttons_centre/Move2.text,"Player",data.Player,data.Enemy)
	$Cast/darken.hide()
	$backround_layer/darken.hide()
	$Castless/Box_and_buttons_centre.hide()
func kill_enemy():
	var rand = randi_range(1,5)
	var money_payout = 100 * rand
	data.Money += money_payout
	init_money()
	$SFX/faint.play()
	data.battle_num += 1
	faint.emit("Enemy")
	add_exp(data.Enemy.level * 10)
	save_data()
	data.Enemy = {}
	await get_tree().create_timer(2).timeout
	if catchable == false:
		next_mon()
		return
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
	refresh_new_move_selection()
	get_new_move.emit(data.Player)
	evolve.emit(data.Player.name,data.Player.level)
func set_max_exp():
	data.Player.max_exp = data.Player.level * 30
	$Cast/Player/xpbar.max_value = data.Player.max_exp
func Move3():
	if $Castless/Box_and_buttons_centre/Move3.text == "":$Cast/darken.hide();$backround_layer/darken.hide();$Castless/Box_and_buttons_centre.hide();return
	Attack.emit($Castless/Box_and_buttons_centre/Move3.text,"Player",data.Player,data.Enemy)
	$Cast/darken.hide()
	$backround_layer/darken.hide()
	$Castless/Box_and_buttons_centre.hide()
func Move4():
	if $Castless/Box_and_buttons_centre/Move4.text == "":$Cast/darken.hide();$backround_layer/darken.hide();$Castless/Box_and_buttons_centre.hide();return
	Attack.emit($Castless/Box_and_buttons_centre/Move4.text,"Player",data.Player,data.Enemy)
	$Cast/darken.hide()
	$backround_layer/darken.hide()
	$Castless/Box_and_buttons_centre.hide()
func pokemon_data(pkmn,type2,base,ability):
	player_mon.clear()
	player_mon.append(pkmn)
	player_mon.append(type2)
	player_mon.append(ability)
	bst = base
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
			#level_up()
			#data.Player.hp -= 20
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
	if key == "poke_ball" and catchable == false: $"Timers/after_attack cooldown".start(); disable_btns(true)
	run_items.emit(key,data.Enemy)
func shop():
	Globals.money = data.Money
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
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
						"spatk": data.Enemy.prespatk,
						"spdef": data.Enemy.prespdef,
						"level": data.Enemy.level,
						"type2": data.Enemy.type2,
						"exp": 0,
						"max_exp" : null,
						"faint" : false,
						"name": data.Enemy.sprite,
						"max_hp": null,
						"Move1": data.Enemy.move1,
						"Move2": data.Enemy.move2,
						"Move3": data.Enemy.move3,
						"Move4": data.Enemy.move4,
						"Ability": data.Enemy.ability,
						"item": null,
						"status":null,
						"status_value": 0,
						"status_value2": 0, 
					}
					update_moves()
					refine_level_stats(data.Player1,false,true)
					data.Player1.max_hp = data.Player1.hp
				1:
					data.Player2 = {
						"index": 2,
						"hp": data.Enemy.prehp,
						"def": data.Enemy.predef,
						"atk": data.Enemy.preatk,
						"spd": data.Enemy.prespd,
						"spatk": data.Enemy.prespatk,
						"spdef": data.Enemy.prespdef,
						"level": data.Enemy.level,
						"type": data.Enemy.type,
						"exp": 0,
						"max_exp" : null,
						"faint" : false,
						"name": data.Enemy.sprite,
						"max_hp": null,
						"type2": data.Enemy.type2,
						"Move1": data.Enemy.move1,
						"Move2": data.Enemy.move2,
						"Move3": data.Enemy.move3,
						"Move4": data.Enemy.move4,
						"Ability": data.Enemy.ability,
						"item": null,
						"status":null,
						"status_value": 0, 
						"status_value2": 0,
					}
					update_moves()
					refine_level_stats(data.Player2,false,true)
					data.Player2.max_hp = data.Player2.hp
				2:
					data.Player3 = {
						"index": 3,
						"hp": data.Enemy.prehp,
						"def": data.Enemy.predef,
						"atk": data.Enemy.preatk,
						"spd": data.Enemy.prespd,
						"spatk": data.Enemy.prespatk,
						"spdef": data.Enemy.prespdef,
						"level": data.Enemy.level,
						"type": data.Enemy.type,
						"exp": 0,
						"max_exp" : null,
						"faint" : false,
						"name": data.Enemy.sprite,
						"max_hp": null,
						"type2": data.Enemy.type2,
						"Move1": data.Enemy.move1,
						"Move2": data.Enemy.move2,
						"Move3": data.Enemy.move3,
						"Move4": data.Enemy.move4,
						"Ability": data.Enemy.ability,
						"item": null,
						"status":null,
						"status_value": 0, 
						"status_value2": 0,
					}
					update_moves()
					refine_level_stats(data.Player3,false,true)
					data.Player3.max_hp = data.Player3.hp
				3:
					data.Player4 = {
						"index": 4,
						"hp": data.Enemy.prehp,
						"def": data.Enemy.predef,
						"atk": data.Enemy.preatk,
						"spd": data.Enemy.prespd,
						"spatk": data.Enemy.prespatk,
						"spdef": data.Enemy.prespdef,
						"level": data.Enemy.level,
						"type": data.Enemy.type,
						"exp": 0,
						"max_exp" : null,
						"faint" : false,
						"name": data.Enemy.sprite,
						"max_hp": null,
						"type2": data.Enemy.type2,
						"Move1": data.Enemy.move1,
						"Move2": data.Enemy.move2,
						"Move3": data.Enemy.move3,
						"Move4": data.Enemy.move4,
						"Ability": data.Enemy.ability,
						"item": null,
						"status":null,
						"status_value": 0, 
						"status_value2": 0,
					}
					update_moves()
					refine_level_stats(data.Player4,false,true)
					data.Player4.max_hp = data.Player4.hp
				4:
					data.Player5 = {
						"index": 5,
						"hp": data.Enemy.prehp,
						"def": data.Enemy.predef,
						"atk": data.Enemy.preatk,
						"spd": data.Enemy.prespd,
						"spatk": data.Enemy.prespatk,
						"spdef": data.Enemy.prespdef,
						"level": data.Enemy.level,
						"type": data.Enemy.type,
						"exp": 0,
						"max_exp" : null,
						"faint" : false,
						"name": data.Enemy.sprite,
						"max_hp": null,
						"type2": data.Enemy.type2,
						"Move1": data.Enemy.move1,
						"Move2": data.Enemy.move2,
						"Move3": data.Enemy.move3,
						"Move4": data.Enemy.move4,
						"Ability": data.Enemy.ability,
						"item": null,
						"status":null,
						"status_value": 0, 
						"status_value2": 0,
					}
					update_moves()
					refine_level_stats(data.Player5,false,true)
					data.Player5.max_hp = data.Player5.hp
				5:
					data.Player6 = {
						"index": 6,
						"hp": data.Enemy.prehp,
						"def": data.Enemy.predef,
						"atk": data.Enemy.preatk,
						"spd": data.Enemy.prespd,
						"spatk": data.Enemy.prespatk,
						"spdef": data.Enemy.prespdef,
						"level": data.Enemy.level,
						"type": data.Enemy.type,
						"exp": 0,
						"max_exp" : null,
						"faint" : false,
						"name": data.Enemy.sprite,
						"max_hp": null,
						"type2": data.Enemy.type2,
						"Move1": data.Enemy.move1,
						"Move2": data.Enemy.move2,
						"Move3": data.Enemy.move3,
						"Move4": data.Enemy.move4,
						"Ability": data.Enemy.ability,
						"item": null,
						"status":null,
						"status_value": 0,
						"status_value2": 0, 
					}
					update_moves()
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
	if data.battle_num % 5 == 0 and data.battle_num != 0:
		$Cast/Enemy/Enemy_sprite.hide()
		trainer(data.battle_num / 5)
	else:
		if data.battle_num < 5 and data.battle_num >= 0:
			print("working")
			random_enemy(5, 7, 1)
		if data.battle_num < 10 and data.battle_num > 5:
			random_enemy(5, 7, 1)
		if data.battle_num < 15 and data.battle_num > 10:
			random_enemy(7, 9, 1)
		if data.battle_num < 20 and data.battle_num > 15:
			random_enemy(10, 12, 1)
func RandMon(type,type2,pk_name,base_stat,ability):
	rand_mon = [type,type2,pk_name,base_stat,ability]
func Mov_return(mov):
	movs.append(mov)
func update_moves():
	$Castless/Box_and_buttons_centre/Move1.text = data.Player.Move1
	$Castless/Box_and_buttons_centre/Move2.text = data.Player.Move2
	$Castless/Box_and_buttons_centre/Move3.text = data.Player.Move3
	$Castless/Box_and_buttons_centre/Move4.text = data.Player.Move4
func trainer(index):
	trainer_battle.emit(index)
func _on_trainers_text(text):
	textedit(text)
func Party(party):
	Trainer_Party = party
	data.Enemy = {}
	data.Enemy = party.first
	catchable = false
	init_enemy()
	left = 1
func init_enemy():
	$Cast/Enemy/Enemy_sprite.position.y -= .1
	$Cast/Enemy/Enemy_sprite.scale = Vector2(3,3)
	$Cast/Enemy/Enemy_sprite.show()
	$Cast/Enemy/Enemy_sprite.texture = load("res://assets/pokemon/"+data.Enemy.name+"/front.png")
	movs.clear()
	randmov.emit(data.Enemy.name)
	randmov.emit(data.Enemy.name)
	randmov.emit(data.Enemy.name)
	randmov.emit(data.Enemy.name)
	data.Enemy["move1"] = null
	data.Enemy["move2"] = null
	data.Enemy["move3"] = null
	data.Enemy["move4"] = null
	data.Enemy.move1 = movs[0]
	data.Enemy.move2 = movs[1]
	data.Enemy.move3 = movs[2]
	data.Enemy.move4 = movs[3]
	refine_level_stats(data.Enemy,false,true)
	set_types()
	set_levels("both")
	reset_bars()
	cap_bars()
	if data.Player.spd >= data.Enemy.spd:
		speeddiff = "Player"
	else:
		speeddiff = "Enemy"
	if speeddiff == "Enemy":
		disable_btns(true)
		$"Timers/after_attack cooldown".start()
	else:
		pass
func next_mon():
	left += 1
	match left:
		2:
			if Trainer_Party.second != null:
				data.Enemy = Trainer_Party.second
				init_enemy()
		3:
			if Trainer_Party.third != null:
				data.Enemy = Trainer_Party.third
				init_enemy()
		4:
			if Trainer_Party.forth != null:
				data.Enemy = Trainer_Party.forth
				init_enemy()
		5:
			if Trainer_Party.fifth != null:
				data.Enemy = Trainer_Party.fifth
				init_enemy()
		6:
			if Trainer_Party.sixth != null:
				data.Enemy = Trainer_Party.sixth
				init_enemy()
		
	data.battle_num += 1
	catchable = true
	next_enemy()
func _on_abilities_damage_text(text: String) -> void:
	$top_layer/ability/Label.text = text
	var tween = get_tree().create_tween()
	var ogpos = $top_layer/ability.position
	var newpos = $top_layer/ability.position - Vector2(210,0)
	tween.tween_property($top_layer/ability,"position",newpos,1)
	await get_tree().create_timer(1).timeout
	var tweene = get_tree().create_tween()
	tweene.tween_property($top_layer/ability,"position",ogpos,1)
	await get_tree().create_timer(1).timeout
	$top_layer/ability/Label.text = ""
func read_item():
	HeldItem.emit(data.Player,"Player")
	HeldItem.emit(data.Enemy,"Enemy")
func loseitem(who: Variant) -> void:
	match who:
		"Enemy":
			data.Enemy.item = null
		"Player":
			data.Player.item = null
func item_return(who: Variant, effect: Variant, num: Variant) -> void:
	match who:
		"Player":
			match effect:
				"hp":
					data.Player.hp = num
		"Enemy":
			match effect:
				"hp":
					data.Enemy.hp = num
	reset_bars()
func evolveit(mon: Variant) -> void:
	$Cast/Player/Player_sprite.texture = load("res://assets/pokemon/"+mon+"/back.png")
	var pk = pokemon.new()
	var new_stats = pk.evodata(mon,data.Player.name)
	data.Player.name = mon
	recalc_evo_stats(new_stats)
func recalc_evo_stats(stats):
	data.Player.ability = stats[1]
	var hp_sub = stats[2].hp
	var spd_sub = stats[2].spd
	var atk_sub = stats[2].atk
	var def_sub = stats[2].def
	var spatk_sub = stats[2].spatk
	var spdef_sub = stats[2].spdef
	var hp_add = stats[0].hp
	var spd_add = stats[0].spd
	var atk_add = stats[0].atk
	var def_add = stats[0].def
	var spatk_add = stats[0].spatk
	var spdef_add = stats[0].spdef
	data.Player.atk -= atk_sub
	data.Player.spd -= spd_sub
	data.Player.def -= def_sub
	data.Player.hp -= hp_sub
	data.Player.spatk -= spatk_sub
	data.Player.spdef -= spdef_sub
	data.Player.atk += atk_add
	data.Player.def += def_add
	data.Player.spd += spd_add
	data.Player.hp += hp_add
	data.Player.spatk += spatk_add
	data.Player.spdef += spdef_add
func refresh_new_move_selection():
	$Castless/New_Move/ItemList.set_item_text(0,$Castless/Box_and_buttons_centre/Move1.text)
	$Castless/New_Move/ItemList.set_item_text(1,$Castless/Box_and_buttons_centre/Move2.text)
	$Castless/New_Move/ItemList.set_item_text(2,$Castless/Box_and_buttons_centre/Move3.text)
	$Castless/New_Move/ItemList.set_item_text(3,$Castless/Box_and_buttons_centre/Move4.text)
func lvlup_mov(mov: Variant) -> void:
	$Castless/New_Move.show()
	$Castless/New_Move/Label2.text = mov
func new_mov_btn_clk(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	match index:
		0:
			$Castless/Box_and_buttons_centre/Move1.text = $Castless/New_Move/Label2.text
		1:
			$Castless/Box_and_buttons_centre/Move2.text = $Castless/New_Move/Label2.text
		2:
			$Castless/Box_and_buttons_centre/Move3.text = $Castless/New_Move/Label2.text
		3:
			$Castless/Box_and_buttons_centre/Move4.text = $Castless/New_Move/Label2.text
		4:
			$Castless/New_Move.hide()
	$Castless/New_Move.hide()
func set_names(n):
	match n:
		"P":
			$Cast/Player/name.text = data.Player.name
		"E":
			$Cast/Enemy/name.text = data.Enemy.sprite
func statify(statdict: Variant,entity) -> void:
	match statdict.status:
		"para":
			match entity:
				"Player":
					data.Player.status = "para"
					data.Player.status_value = statdict.value
					data.Player.status_value2 = data.Player.spd
					data.Player.spd /= 2
				"Enemy":
					data.Enemy.status = "para"
					data.Enemy.status_value = statdict.value
					data.Enemy.status_value2 = data.Enemy.spd
					data.Enemy.spd /= 2
func move_failed_by_status(text: Variant, entity) -> void:
	textedit(text)
	match entity:
		"Player":
			data.Player.status_value -= 1
			if data.Player.status_value == 0:
				match data.Player.status:
					"para":
						data.Player.spd = data.Player.status_value2
						
				data.Player.status = null
		"Enemy":
			data.Enemy.status_value -= 1
			if data.Enemy.status_value == 0:
				match data.Enemy.status:
					"para":
						data.Enemy.spd = data.Enemy.status_value2
						
				data.Enemy.status = null
func _on_damage_heal(hp: int,entity) -> void:
	match entity:
		"Player":
			if data.Player.hp + hp > data.Player.max_hp:
				data.Player.hp = data.Player.max_hp
			else:
				data.Player.hp += hp

		"Enemy":
			if data.Enemy.hp + hp > data.Enemy.max_hp:
				data.Enemy.hp = data.Enemy.max_hp
			else:
				data.Enemy.hp += hp
func flinch(entity) -> void:
	match entity:
		"Player":
			textedit("You flintched!")
		"Enemy":
			textedit("They flinched!")
func _process(_delta: float) -> void:
	update_display()
func update_display():
	set_types()
	reset_bars()
	if damage_state == true: reset_bars()
func _on_damage_state_disabler_timeout() -> void:
	damage_state = false
