extends Control
@onready var Main = load("res://scripts/main_window.gd")
func _ready():
	Main = Main.new()
