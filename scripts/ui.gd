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
func init(Player,Enemy):
	money.text = str(Globals.money) + "$"
	p_hpbar.max_value = Player.hp
	p_hpbar.value = Player.hp
	p_exp.max_value = Player.max_exp
	p_exp.value = Player.exp
	p_type.text = Player.type1 + ", "+Player.type2
	p_name.text = Player.name.capitalize()
	p_level.text = "Lvl. " + str(Player.level)
	p_texture.texture = load("res://assets/pokemon/"+Player.name+"/back.png")
	e_hpbar.max_value = Enemy.hp
	e_hpbar.value = Enemy.hp
	e_type.text = Enemy.type1 + ", "+Enemy.type2
	e_name.text = Enemy.name.capitalize()
	e_level.text = "Lvl. " + str(Enemy.level)
	e_texture.texture = load("res://assets/pokemon/"+Enemy.name+"/front.png")


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
