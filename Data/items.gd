extends Control
@export var res : Sprite2D
@export var MainScene : Control
@export var player : Sprite2D
@export var enemy : Sprite2D
func Item(ItemName):
	match ItemName:
		"potion":
			MainScene.Player.hp += 20
			if MainScene.Player.hp > MainScene.Player.max_hp:
				MainScene.Player.hp = MainScene.Player.max_hp
		"pokeball":
			print("Loaded")
			res.position = player.global_position
			res.texture = load("res://assets/items/pokeball.png")
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
			res.hide()
			enemy.hide()
			await get_tree().create_timer(.2).timeout
			res.position = res.position - Vector2(x,y)
			res.rotation = 0
			res.show()
			var tweenw = get_tree().create_tween()
			tweenw.tween_property(res,"position",Vector2(res.position.x,res.position.y + 100),1)
			await get_tree().create_timer(1).timeout