extends Control

@onready var menu = preload("res://scenes/menu.tscn")

func _ready():
	add_child(menu.instantiate())
