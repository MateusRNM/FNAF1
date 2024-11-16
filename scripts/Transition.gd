extends Control

@onready var staticEffect = $static
@onready var freddy = $freddy
@onready var title = $title
@onready var newGameBtn = $newGameBTn
@onready var continueBtn = $continueBtn
@onready var background = $background
@onready var nightInfoScene = preload("res://scenes/NightInfo.tscn")
var timer = 0.0

func _process(delta):
	if(timer >= 8.0):
		get_parent().add_child(nightInfoScene.instantiate())
		queue_free()
	
	if(timer >= 6.0):
		background.modulate.r -= 0.005
		background.modulate.g -= 0.005
		background.modulate.b -= 0.005
		
	if(timer >= 0.5):
		background.visible = true
		freddy.modulate.a -= 0.005
		title.modulate.a -= 0.005
		newGameBtn.modulate.a -= 0.005
		continueBtn.modulate.a -= 0.005
		staticEffect.modulate.a -= 0.005
	
	timer += delta
