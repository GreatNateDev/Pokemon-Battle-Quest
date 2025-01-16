class_name Trainers
Check(id):
	match id:
		1:
			
		2:
			pass
		3:
			pass
		4:
			pass
			
			
			
func CreateTrainer(Name,Text,Level,Party)
	Party = CreateParty(Party,Level)
	return {
		"name": Name,
		"text": Text,
		"party": Party
	}
	func CreateParty(Party,Level):
		