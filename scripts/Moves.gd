extends Control
signal text(text,unblock,entity)
signal damage(entity,damage,text,type)
#signal effects(entity,effect)
var opp = null
var critical = 1
@onready var anim = get_parent().get_node("AnimationPlayer")
@onready var critp = get_parent().get_node("top_layer/CRIT")
@onready var timer = get_parent().get_node("top_layer/CRIT_timer")
func _on_main_window_attack(Move, Entity, Stats, OStats):
	var miss = randi_range(1,10)
	if miss == 8:
		text.emit("The "+Entity+"'s attack missed! Unlucky!",true,Entity)
		return "ms"
	var crit = randi_range(1,10)
	if crit == 8:
		timer.start()
	if Entity == "Player":
		opp = "Enemy"
	elif Entity == "Enemy":
		opp = "Player"
	match Move:
		"Watergun":
			if Stats.atk /OStats.def <= 0:
				damage.emit(Entity,1 * critical,Entity+" Weakly used WaterGun on the "+opp,"Water")
			else:
				damage.emit(Entity,Stats.atk * critical /OStats.def ,Entity+" Used WaterGun on the "+opp,"Water")
			anim.play(Entity+"_watergun")
		"Bite":
			if Stats.atk /OStats.def <= 0:
				damage.emit(Entity,1 * critical,Entity+" Weakly used Bite on the "+opp,"Dark")
			else:
				damage.emit(Entity,Stats.atk * critical /OStats.def ,Entity+" Bit the "+opp,"Dark")
			anim.play(Entity+"_bite")
		"Ember":
			if Stats.atk /OStats.def <= 0:
				damage.emit(Entity,1 * critical /OStats.def,Entity+" Weakly shot a bolt of fire at the "+opp,"Fire")
			else:
				damage.emit(Entity,Stats.atk * critical /OStats.def ,Entity+" Shot a bolt of fire at the "+opp,"Fire")
				anim.play(Entity+"_ember")
		"Absorb":
			if Stats.atk /OStats.def <= 0:
				damage.emit(Entity,1 * critical /OStats.def,Entity+" Weakly absorbed the "+opp+"s hp!","Grass")
			else:
				damage.emit(Entity,Stats.atk * critical /OStats.def ,Entity+" Absorbed the "+opp+"s hp!","Grass")
				anim.play(Entity+"_absorb")
	critical = 1


func _on_crit_timer_timeout():
	if opp == "Enemy":
			critp.position = Vector2(1539,254)
			critp.emitting = true
			critical = 1.5
	elif opp == "Player":
		critp.position = Vector2(624,727)
		critp.emitting = true
		critical = 1.5
