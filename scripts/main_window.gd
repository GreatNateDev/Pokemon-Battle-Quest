extends Control
var utils = util.new()
var data = savedata.new()
func _ready() -> void:
	connect_sigs()
	if Globals.loader == false and Globals.back_shop == false:
		utils.bars()

	

func Save_Change_Return(changed_data):
	data = changed_data
func connect_sigs():
	utils.Save_Changed.connect(Save_Change_Return)
