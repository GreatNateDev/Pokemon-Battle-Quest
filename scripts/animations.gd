extends Control
@onready var absorb = get_parent().get_node("Move_layer/absorb")
@onready var Enemypos = get_parent().get_node("Cast/Enemy/Enemy_sprite")
@onready var Playerpos = get_parent().get_node("Cast/Player/Player_sprite")
func Animation(entity, move):
	match move:
		"Absorb":
			match entity:
				"Player":
					absorb.show()
					var tween = get_tree().create_tween()
					absorb.position = Enemypos.position
					#set tween delay to 10 for debugging
					tween.tween_property(absorb,"position",Playerpos.position,10)
					await get_tree().create_timer(.5).timeout
