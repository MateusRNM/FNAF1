extends Control

@export var nightCompleted = 5
var timer = 0
var initialAnimFinished = false
const menu = preload("res://scenes/menu.tscn")

func _ready():
	$background.animation = "night" + String.num_int64(nightCompleted)
	$Audio6thNight.play()

func _process(delta):
	if(!initialAnimFinished):
		$background.modulate.r += 0.01
		$background.modulate.g += 0.01
		$background.modulate.b += 0.01
		if($background.modulate.r >= 1):
			$background.modulate.r = 1
			$background.modulate.g = 1
			$background.modulate.b = 1
			initialAnimFinished = true
	if(timer >= 17.5):
		get_parent().add_child(menu.instantiate())
		queue_free()
		return
	if(timer >= 16):
		$background.modulate.r -= 0.01
		$background.modulate.g -= 0.01
		$background.modulate.b -= 0.01
		if($background.modulate.r < 0.2):
			$background.modulate.r = 0.2
			$background.modulate.g = 0.2
			$background.modulate.b = 0.2
	
	timer += delta
