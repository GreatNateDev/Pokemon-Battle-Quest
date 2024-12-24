extends Control
@export var MainScene : Control
func Item(ItemName):
	match ItemName:
		"potion":
			MainScene.Player.hp += 20
			if MainScene.Player.hp > MainScene.Player.max_hp:
				MainScene.Player.hp = MainScene.Player.max_hp
		"pokeball":
			
