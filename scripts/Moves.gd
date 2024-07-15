extends Control
signal text(text)
signal damage(entity,damage)
signal effects(entity,effect)
func Attack(Move,Entity,Stats):
	match Move:
		"Slap":
			damage.emit("Player",1)

