extends Control
@export var container : Container
@export var darken : CanvasModulate
@export var bag_exit : Control
@export var bag : Control
@export var odarken : CanvasModulate
@export var ui : Control
@export var items : Control
func update_bag():
	for child in container.get_children():
		child.queue_free()
	for key in Globals.items.keys():
		var new_button : TextureButton = TextureButton.new()
		var new_text : Label = Label.new()
		container.add_child(new_button)
		new_button.add_child(new_text)
		new_text.position = new_button.position
		new_text.position.y += 30
		new_text.text = str(Globals.items[key])
		new_button.add_to_group("ItemButton")
		new_button.texture_normal = load("res://assets/items/"+str(key)+".png")
		new_button.pressed.connect(Item_pressed.bind(key))
func Item_pressed(key):
	Globals.items[key] -= 1
	if Globals.items[key] == 0:
		var texture_to_check = "res://assets/items/"+key+".png"
		for button in get_tree().get_nodes_in_group("ItemButton"):
			if button.texture_normal.resource_path == texture_to_check:
				items.Item(key)
				Globals.items.erase(key)
				button.queue_free()
	else:
		items.Item(key)
	_on_exit_bag_pressed()


func _on_exit_bag_pressed() -> void:
	darken.hide()
	odarken.hide()
	bag.hide()
	bag_exit.hide()
	ui.disable_btns(false)
