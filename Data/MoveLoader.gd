class_name Move_ldr

func init(Stats):
	var f = FileAccess.open("res://Data/Moves.json", FileAccess.READ)
	var json = JSON.parse_string(f.get_as_text())
	f.close()
	
	var moves_array = []
	var matched_moves = {}
	var moves_to_match = Stats.moves
	
	# Match moves and create dictionary
	for move in json:
		if move in moves_to_match:
			matched_moves[move] = move
	
	# If 4 or fewer matches, add all of them
	if matched_moves.size() <= 4:
		for move_name in matched_moves.keys():
			moves_array.append(matched_moves[move_name])
	else:
		# Get first 4 matches only
		var count = 0
		for move_name in matched_moves.keys():
			if count < 4:
				moves_array.append(matched_moves[move_name])
				count += 1
			else:
				break
	return moves_array
