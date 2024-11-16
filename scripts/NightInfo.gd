extends Control

@onready var cameraEffect = $cameraEffect
@onready var infosTxt = $infos
var timer = 0.0
var gameScene = preload("res://scenes/Game.tscn")
	
func _process(delta):
	if(GameVars.night == 1):
		infosTxt.text = "12:00  AM
		1st  Night" 
	elif(GameVars.night == 2):
		infosTxt.text = "12:00  AM
		2nd  Night" 
	elif(GameVars.night == 3):
		infosTxt.text = "12:00  AM
		3rd  Night"
	elif(GameVars.night == 4):
		infosTxt.text = "12:00  AM
		4th  Night"
	elif(GameVars.night == 5):
		infosTxt.text = "12:00  AM
		5th  Night"
	elif(GameVars.night == 6):
		infosTxt.text = "12:00  AM
		6th  Night"
	elif(GameVars.night == 7):
		infosTxt.text = "12:00  AM
		7th  Night"
	if(timer >= 6.0):
		get_parent().add_child(gameScene.instantiate())
		queue_free()
		
	if(timer >= 4.0):
		infosTxt.modulate.a -= 0.0025
	timer += delta
	
	
	
func _on_camera_effect_animation_finished():
	cameraEffect.visible = false
