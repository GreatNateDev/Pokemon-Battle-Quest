extends Control
signal text(text,unblock,entity)
signal damage(entity,damage,text)
signal effects(entity,effect)
var opp = null
@onready var anim = get_parent().get_node("AnimationPlayer")
@onready var weak = get_parent().get_node("weak attack")
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
				damage.emit(Entity,1,Entity+" Weakly slapped the "+opp,"weak")
			else:
				damage.emit(Entity,Stats.atk /OStats.def / 2,Entity+" Slapped the "+opp,"reg")
			anim.play(Entity+"_slap")
		"Kick":
			if (Stats.atk -2) /OStats.def <= 0:
				damage.emit(Entity,1,Entity+" Weakly kicked the "+opp,"weak")
			else:
				damage.emit(Entity,(Stats.atk -2) /OStats.def ,Entity+" Kicked the "+opp,"reg")
			anim.play(Entity+"_kick") 
		"Watergun":
			if Stats.atk /OStats.def <= 0:
				damage.emit(Entity,1,Entity+" Weakly used WaterGun on the "+opp,"weak")
			else:
				damage.emit(Entity,Stats.atk /OStats.def ,Entity+" Used WaterGun on the "+opp,"reg")
			anim.play(Entity+"_watergun")
