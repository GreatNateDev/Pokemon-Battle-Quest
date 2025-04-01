class_name Spawning
var Spawns : Dictionary = {
	"biome1": {
		"mons": ["charmander", "bulbasaur", "squirtle"]
	},
	"biome2": {
		
	},
	"biome3": {
		
	}
}

func Spawn(biome):
	match biome:
		1:
			var start = 0
			var end = Spawns["biome1"]["mons"].size() - 1
			print(end)
			var point = randi_range(start,end)
			return Spawns["biome1"]["mons"][point]
		2:
			pass
		3:
			pass
