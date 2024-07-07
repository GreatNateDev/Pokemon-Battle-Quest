extends GDScript
func slap(entity):
	if entity == "enemy":
		if Main.enemy.atk != 1:
			Main.player.hp -= (Main.enemy.atk / 2)
			textudt("Enemy used slap and did "+str(Main.enemy.atk / 2)+" damage!")
		else:
			player.hp -= 1
			textudt("Enemy used slap and did 1 damage!")
	elif entity == "player":
		if player.atk != 1:
			enemy.hp -= (player.atk / 2)
			textudt("Nate used slap and did "+str(player.atk / 2)+" damage!")
		else:
			enemy.hp -= 1
			textudt("Nate used slap and did 1 damage!")
