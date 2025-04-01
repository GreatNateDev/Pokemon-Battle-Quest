extends Control
@export var money : Label
@export var p_hpbar : ProgressBar
@export var p_type : Label
@export var p_name : Label
@export var p_level : Label
@export var p_exp : ProgressBar
@export var p_texture : Sprite2D
@export var e_hpbar : ProgressBar
@export var e_type : Label
@export var e_name : Label
@export var e_level : Label
@export var e_texture : Sprite2D
@export var darken : CanvasModulate
@export var fightbuttons : Control
@export var move1 : Button
@export var move2 : Button
@export var move3 : Button
@export var move4 : Button
@export var text : Label
@export var bag : Button
@export var swap : Button
@export var run : Button
@export var fight : Button
@export var p_sprite : Sprite2D
@export var e_sprite : Sprite2D
@export var music : AudioStreamPlayer2D
@export var faint_sfx : AudioStreamPlayer2D
@export var swap_menu : ItemList
@export var swap_menu_root : Control
@export var main : Control # Dont use this to much please
func init(Player,Enemy):
	p_exp.max_value = Player.max_exp
	p_exp.value = Player.exp
	money.text = str(Globals.money) + "$"
	p_hpbar.max_value = Player.hp
	p_hpbar.value = Player.hp
	p_exp.max_value = Player.max_exp
	p_exp.value = Player.exp
	p_type.text = Player.type1 + ", "+Player.type2
	p_name.text = Player.name.capitalize()
	p_level.text = "Lvl. " + str(int(Player.level))
	p_texture.texture = load("res://assets/pokemon/"+Player.name+"/back.png")
	e_hpbar.max_value = Enemy.hp
	e_hpbar.value = Enemy.hp
	e_type.text = Enemy.type1 + ", "+Enemy.type2
	e_name.text = Enemy.name.capitalize()
	e_level.text = "Lvl. " + str(Enemy.level)
	e_texture.texture = load("res://assets/pokemon/"+Enemy.name+"/front.png")
	if main.isTrainer == true:
		e_texture.hide()
		play_trainer_anim()


func Fight_Pressed() -> void:
	darken.show()
	fightbuttons.show()
	if Globals.moves == null || Globals.moves.size() == 0:
		return
		
	var buttons = [move1, move2, move3, move4]
	for i in range(buttons.size()):
		if i < Globals.moves.size() && Globals.moves[i] != null:
			buttons[i].text = Globals.moves[i]
		else:
			buttons[i].text = ""
	
func endFight():
	darken.hide()
	fightbuttons.hide()
func reset_bars(entity, hp):
	match entity:
		"Player":
			await get_tree().create_timer(.5).timeout
			get_tree().create_tween().tween_property(p_hpbar,"value",hp,.5)

		"Enemy":
			await get_tree().create_timer(.5).timeout
			get_tree().create_tween().tween_property(e_hpbar,"value",hp,.5)
func textedit(texte):
	get_tree().create_tween().tween_property(text,"text",texte,.3)
func disable_btns(value):
	fight.disabled = value
	run.disabled = value
	bag.disabled = value
	swap.disabled = value
func faint(entity):
	#play faint sfx
	#add triggers for below if trainer / has more mon
	match entity:
		"Player":
			await get_tree().create_timer(.5).timeout
			stop_audio()
			faint_sfx.play()
			get_tree().create_tween().tween_property(p_sprite,"scale",Vector2(0,0),1).set_ease(Tween.EASE_OUT)
			get_tree().create_tween().tween_property(p_sprite,"position",Vector2(p_sprite.position.x,p_sprite.position.y+100),1).set_ease(Tween.EASE_OUT)
			textedit("You fainted!")
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_file("res://scenes/Menu.tscn")
		"Enemy":
			await get_tree().create_timer(.5).timeout
			stop_audio()
			faint_sfx.play()
			get_tree().create_tween().tween_property(e_sprite,"scale",Vector2(0,0),1).set_ease(Tween.EASE_OUT)
			get_tree().create_tween().tween_property(e_sprite,"position",Vector2(e_sprite.position.x,e_sprite.position.y+50),1).set_ease(Tween.EASE_OUT)
func stop_audio():
	music.stop()
func update_exp():
	get_tree().create_tween().tween_property(p_exp,"value",main.Player.exp,.5)
func play_trainer_anim():
	var trainersprite = load("res://assets/trainers/"+Globals.trainer.to_lower()+".png")
	var old = e_texture.texture
	e_texture.texture = trainersprite
	e_texture.show()
	var old_pos = e_texture.position
	var new_x = e_texture.position.x + 400 
	var new_y = e_texture.position.y
	await get_tree().create_timer(1).timeout
	await get_tree().create_tween().tween_property(e_texture,"position",Vector2(new_x,new_y),1).finished
	e_texture.texture = old 
	e_texture.position = old_pos
func UpdateSwapMenu():
	if swap_menu_root.visible == false:
		if Globals.mon1 != null:
			swap_menu.set_item_icon(0,load("res://assets/pokemon/"+Globals.mon1.name+"/front.png"))
			swap_menu.set_item_text(0, Globals.mon1.name)
		elif Globals.mon2 != null:
			swap_menu.set_item_icon(1,load("res://assets/pokemon/"+Globals.mon2.name+"/front.png"))
			swap_menu.set_item_text(1, Globals.mon2.name)
		elif Globals.mon3 != null:
			swap_menu.set_item_icon(2,load("res://assets/pokemon/"+Globals.mon3.name+"/front.png"))
			swap_menu.set_item_text(2, Globals.mon3.name)
		elif Globals.mon4 != null:
			swap_menu.set_item_icon(3,load("res://assets/pokemon/"+Globals.mon4.name+"/front.png"))
			swap_menu.set_item_text(3, Globals.mon4.name)
		elif Globals.mon5 != null:
			swap_menu.set_item_icon(4,load("res://assets/pokemon/"+Globals.mon5.name+"/front.png"))
			swap_menu.set_item_text(4, Globals.mon5.name)
		elif Globals.mon6 != null:
			swap_menu.set_item_icon(5,load("res://assets/pokemon/"+Globals.mon6.name+"/front.png"))
			swap_menu.set_item_text(5, Globals.mon6.name)
		swap_menu_root.show()
	elif swap_menu_root.visible == true:
		swap_menu_root.hide()
