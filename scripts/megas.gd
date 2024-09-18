class_name megas
var megs = {
	"charizard" : "charizard_x"
}
func pick(name):
	for names in megs.keys():
		if names == name:
			return megs[name]
		else:
			return null
