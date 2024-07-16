extends Control
signal text(text,unblock,entity)
signal damage(entity,damage,text)
signal effects(entity,effect)
var opp = null
@onready var anim = get_parent().get_node("AnimationPlayer")
func _on_main_window_attack(Move, Entity, Stats, OStats):
	var miss = randi_range(1,10)
	if miss == 8:
		text.emit("The "+Entity+"'s attack missed! Unlucky!",true,Entity)
		return "ms"
	if Entity == "Player":
		opp = "Enemy"
	elif Entity == "Enemy":
		opp = "Player"
	match Move:
		"Slap":
			if Stats.atk /OStats.def / 2 <= 0:
				damage.emit(Entity,1,Entity+" Weakly slapped the "+opp)
			else:
				damage.emit(Entity,Stats.atk /OStats.def / 2,Entity+" Slapped the "+opp)
			anim.play(Entity+"_slap")
		"Kick":
			if (Stats.atk -2) /OStats.def <= 0:
				damage.emit(Entity,1,Entity+" Weakly kicked the "+opp)
			else:
				damage.emit(Entity,(Stats.atk -2) /OStats.def ,Entity+" Kicked the "+opp)
			anim.play(Entity+"_kick") 
