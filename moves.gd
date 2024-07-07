extends Node
func slap(entity):
	if entity == "enemy":
		if Main.enemy.atk != 1:
			Main.player.hp -= (Main.enemy.atk / 2)
			Main.textudt("Enemy used slap and did "+str(Main.enemy.atk / 2)+" damage!")
		else:
			Main.player.hp -= 1
			Main.textudt("Enemy used slap and did 1 damage!")
	elif entity == "player":
		if Main.player.atk != 1:
			Main.enemy.hp -= (Main.player.atk / 2)
			Main.textudt("Nate used slap and did "+str(Main.player.atk / 2)+" damage!")
		else:
			Main.enemy.hp -= 1
			Main.textudt("Nate used slap and did 1 damage!")
