extends Control
@onready var res = get_parent().get_node("Move_layer/move")
@onready var Enemypos = get_parent().get_node("Cast/Enemy/Enemy_sprite")
@onready var Playerpos = get_parent().get_node("Cast/Player/Player_sprite")
func Animation(entity, move):
	match move:
		"Absorb":
			match entity:
				"Player":
					res.texture = load("res://assets/moves/absorb.png")
					res.scale = Vector2(2,2)
					res.show()
					var tween = get_tree().create_tween()
					res.position = Enemypos.global_position
					tween.tween_property(res,"position",Playerpos.global_position,.5)
					await get_tree().create_timer(.5).timeout
					res.hide()
					res.scale = Vector2(1,1)
				"Enemy":
					res.texture = load("res://assets/moves/absorb.png")
					res.scale = Vector2(2,2)
					res.show()
					var tween = get_tree().create_tween()
					res.position = Playerpos.global_position
					tween.tween_property(res,"position",Enemypos.global_position,.5)
					await  get_tree().create_timer(.5).timeout
					res.hide()
					res.scale = Vector2(2,2)
		"Bite":
			match entity:
				"Player":
					res.texture = load("res://assets/moves/bite.png")
					res.hframes = 2
					res.show()
					res.frame = 1
					res.position = Enemypos.global_position
					await get_tree().create_timer(.4).timeout
					res.frame = 0
					await get_tree().create_timer(.2).timeout
					res.hide()
					res.hframes = 1
				"Enemy":
					res.texture = load("res://assets/moves/bite.png")
					res.hframes = 2
					res.show()
					res.frame = 1
					res.position = Playerpos.global_position
					await get_tree().create_timer(.4).timeout
					res.frame = 0
					await get_tree().create_timer(.2).timeout
					res.hide()
					res.hframes = 1
		"Watergun":
			match entity:
				"Player":
					res.texture = load("res://assets/moves/bubble.png")
					res.vframes = 3
					res.frame = 0
					res.scale = Vector2(2,2)
					res.position = Playerpos.global_position
					res.show()
					var tween = get_tree().create_tween()
					tween.tween_property(res,"position",Enemypos.global_position,.5)
					await get_tree().create_timer(.5).timeout
					res.frame = 1
					await get_tree().create_timer(.2).timeout
					res.frame = 2
					await get_tree().create_timer(.2).timeout
					res.hide()
					res.frame = 0
					res.vframes = 1
					res.scale = Vector2(2,2)
				"Enemy":
					res.texture = load("res://assets/moves/bubble.png")
					res.vframes = 3
					res.frame = 0
					res.scale = Vector2(2,2)
					res.position = Enemypos.global_position
					res.show()
					var tween = get_tree().create_tween()
					tween.tween_property(res,"position",Playerpos.global_position,.5)
					await get_tree().create_timer(.5).timeout
					res.frame = 1
					await get_tree().create_timer(.2).timeout
					res.frame = 2
					await get_tree().create_timer(.2).timeout
					res.hide()
					res.frame = 0
					res.vframes = 1
					res.scale = Vector2(2,2)
		"Ember":
			match entity:
				"Player":
					res.texture = load("res://assets/moves/ember.png")
					res.hframes = 5
					res.frame = 0
					res.scale = Vector2(2,2)
					res.position = Enemypos.global_position
					res.show()
					await get_tree().create_timer(.1).timeout
					res.frame = 1
					await get_tree().create_timer(.1).timeout
					res.frame = 2
					await get_tree().create_timer(.1).timeout
					res.frame = 3
					await get_tree().create_timer(.1).timeout
					res.frame = 4
					await get_tree().create_timer(.1).timeout
					res.hide()
					res.frame = 0
					res.hframes = 1
					res.scale = Vector2(1,1)
				"Enemy":
					res.texture = load("res://assets/moves/ember.png")
					res.hframes = 5
					res.frame = 0
					res.scale = Vector2(2,2)
					res.position = Playerpos.global_position
					res.show()
					await get_tree().create_timer(.1).timeout
					res.frame = 1
					await get_tree().create_timer(.1).timeout
					res.frame = 2
					await get_tree().create_timer(.1).timeout
					res.frame = 3
					await get_tree().create_timer(.1).timeout
					res.frame = 4
					await get_tree().create_timer(.1).timeout
					res.hide()
					res.frame = 0
					res.hframes = 1
					res.scale = Vector2(1,1)
					
