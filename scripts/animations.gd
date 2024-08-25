extends Control
@onready var res = get_parent().get_node("Move_layer/move")
@onready var Enemypos = get_parent().get_node("Cast/Enemy/Enemy_sprite")
@onready var Playerpos = get_parent().get_node("Cast/Player/Player_sprite")
func faint(entity):
	match entity:
		"Player":
			var tweene = get_tree().create_tween()
			var tween = get_tree().create_tween()
			var pos = Playerpos.position.y + 50
			tween.tween_property(Playerpos,"scale",Vector2(.1,.1),.5)
			tweene.tween_property(Playerpos,"position",Vector2(Playerpos.position.x,pos),5)
			await get_tree().create_timer(.5).timeout
			Playerpos.hide()
			await get_tree().create_timer(3).timeout
		"Swap":
			await get_tree().create_timer(3).timeout
			var tweene = get_tree().create_tween()
			var tween = get_tree().create_tween()
			var pos = Playerpos.position.y - 50
			Playerpos.show()
			tween.tween_property(Playerpos,"scale",Vector2(3,3),.5)
			tweene.tween_property(Playerpos,"position",Vector2(Playerpos.position.x,pos),.5)
			await get_tree().create_timer(.5).timeout
			await get_tree().create_timer(3).timeout
		"Enemy":
			var tweene = get_tree().create_tween()
			var tween = get_tree().create_tween()
			var pos = Enemypos.position.y + .1
			tween.tween_property(Enemypos,"scale",Vector2(.1,.1),.5)
			tweene.tween_property(Enemypos,"position",Vector2(Enemypos.position.x,pos),5)
			await get_tree().create_timer(.5).timeout
			Enemypos.hide()
func Animation(entity, move):
	var target = Enemypos if entity == "Player" else Playerpos
	var source = Playerpos if entity == "Player" else Enemypos
	match move:
		"Absorb":
				res.texture = load("res://assets/moves/absorb.png")
				res.scale = Vector2(2,2)
				res.show()
				var tween = get_tree().create_tween()
				res.position = target.global_position
				tween.tween_property(res,"position",source.global_position,.5)
				await get_tree().create_timer(.5).timeout
				res.hide()
				res.scale = Vector2(1,1)
		"Bite":
				res.texture = load("res://assets/moves/bite.png")
				res.scale = Vector2(2,2)
				res.hframes = 2
				res.show()
				res.frame = 1
				res.position = target.global_position
				await get_tree().create_timer(.4).timeout
				res.frame = 0
				await get_tree().create_timer(.2).timeout
				res.hide()
				res.hframes = 1
				res.scale = Vector2(1,1)
		"Watergun":
				res.texture = load("res://assets/moves/bubble.png")
				res.vframes = 3
				res.frame = 0
				res.scale = Vector2(2,2)
				res.position = source.global_position
				res.show()
				var tween = get_tree().create_tween()
				tween.tween_property(res,"position",target.global_position,.5)
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
				res.texture = load("res://assets/moves/ember.png")
				res.hframes = 5
				res.frame = 0
				res.scale = Vector2(2,2)
				res.position = target.global_position
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
		"Tackle":
			res.texture = load("res://assets/moves/tackle.png")
			res.position = target.global_position
			res.scale = Vector2(2,2)
			var tween = get_tree().create_tween()
			var pos = source.global_position + Vector2(50,0)
			var curpos = source.global_position
			tween.tween_property(source,"global_position",pos,.3)
			await get_tree().create_timer(.3).timeout
			var tweene = get_tree().create_tween()
			tweene.tween_property(source,"global_position",curpos,.3)
			res.show()
			await get_tree().create_timer(.3).timeout
			res.hide()
			res.scale = Vector2(1,1)
		"Vinewhip":
			res.texture = load("res://assets/moves/vine_whip.png")
			res.position = target.global_position
			res.scale = Vector2(3,3)
			res.position.x -= 32
			res.vframes = 5
			res.frame = 0
			res.show()
			await get_tree().create_timer(.2).timeout
			res.frame = 1
			await get_tree().create_timer(.2).timeout
			res.frame = 2
			await get_tree().create_timer(.2).timeout
			res.frame = 3
			await get_tree().create_timer(.2).timeout
			res.frame = 4
			await get_tree().create_timer(.2).timeout
			res.hide()
			res.scale = Vector2(1,1)
			res.vframes = 1
			res.frame = 0
		"Thunderbolt":
			res.texture = load("res://assets/moves/thunderbolt.png")
			res.position = target.global_position
			res.scale = Vector2(2,2)
			res.vframes = 5
			res.frame = 0
			res.position.y += 16
			var ln2 = Sprite2D.new()
			res.add_sibling(ln2)
			ln2.texture = load("res://assets/moves/thunderbolt.png")
			ln2.position = res.position
			ln2.position.y -= 64
			ln2.scale = Vector2(2,2)
			ln2.vframes = 5
			ln2.frame = 0
			var ln3 = Sprite2D.new()
			res.add_sibling(ln3)
			ln3.texture = load("res://assets/moves/thunderbolt.png")
			ln3.position = ln2.position
			ln3.position.y -= 64
			ln3.scale = Vector2(2,2)
			ln3.vframes = 5
			ln3.frame = 0
			var ln4 = Sprite2D.new()
			res.add_sibling(ln4)
			ln4.texture = load("res://assets/moves/thunderbolt.png")
			ln4.position = ln3.position
			ln4.position.y -= 64
			ln4.scale = Vector2(2,2)
			ln4.vframes = 5
			ln4.frame = 0
			ln2.show()
			ln3.show()
			ln4.show()
			res.show()
			await get_tree().create_timer(.2).timeout
			res.frame = 1
			ln2.frame = 1
			ln3.frame = 1
			ln4.frame = 1
			await get_tree().create_timer(.2).timeout
			res.frame = 2
			ln2.frame = 2
			ln3.frame = 2
			ln4.frame = 2
			await get_tree().create_timer(.2).timeout
			res.frame = 3
			ln2.frame = 3
			ln3.frame = 3
			ln4.frame = 3
			await get_tree().create_timer(.2).timeout
			res.frame = 4
			ln2.frame = 4
			ln3.frame = 4
			ln4.frame = 4
			await get_tree().create_timer(.2).timeout
			res.hide()
			ln2.queue_free()
			ln3.queue_free()
			ln4.queue_free()
			res.scale = Vector2(1,1)
			res.vframes = 1
			res.frame = 0
