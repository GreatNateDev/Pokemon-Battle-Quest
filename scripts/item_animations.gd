extends Control
@onready var res = get_parent().get_node("Move_layer/item")
@onready var player = get_parent().get_node("Cast/Player/Player_sprite")
@onready var enemy = get_parent().get_node("Cast/Enemy/Enemy_sprite")
func Item_anim(item):
	match item:
		"poke_ball":
			res.position = player.global_position
			res.texture = load("res://assets/items/poke_ball.png")
			res.scale = Vector2(2,2)
			res.show()
			var tween = get_tree().create_tween()
			tween.tween_property(res,"position",enemy.global_position,1)
			var tweene = get_tree().create_tween()
			tweene.tween_property(res,"rotation",360,1)
			await get_tree().create_timer(1).timeout
			var x = enemy.get_rect().size.x
			x = x / 2
			var y = enemy.get_rect().size.y
			y = y / 2
			print("x: "+str(x)+" "+"y: "+str(y))
			res.hide()
			await get_tree().create_timer(.2).timeout
			res.position = Vector2(x,y)
			res.show()
			var tweenw = get_tree().create_tween()
			tweenw.tween_property(res,"position",res.position.y + 20,1)
			await get_tree().create_timer(1).timeout
			res.hide()
			res.scale = Vector2(1,1)
