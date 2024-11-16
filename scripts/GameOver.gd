extends Control

var staticFinished = false
var menuTimer = 0.0
const mainMenu = preload("res://scenes/menu.tscn")

func _process(delta):
	if(staticFinished):
		$static.modulate.a -= 0.01
		if(menuTimer >= 8):
			get_parent().add_child(mainMenu.instantiate())
			queue_free()
		else:
			menuTimer += delta

func _on_static_sound_finished():
	staticFinished = true
