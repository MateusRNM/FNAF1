extends Node

var foxySingTimer = 0.0
var doorPoundingTimer = 0.0
var circusMusicTimer = 0.0
var hallucinationsTimer = 0.0
var RNG = RandomNumberGenerator.new()

func verifyEGs(delta):
	if(get_tree().current_scene.get_child(0).jingleActivated):
		return
	foxySing(delta)
	doorPounding(delta)
	circusMusic(delta)
	hallucinations(delta)
	

func foxySing(delta):
	if(foxySingTimer >= 4):
		var random = RNG.randi_range(1, 30)
		foxySingTimer = 0
		if(random == 1):
			if(IA.foxyStage != 3):
				if(!get_tree().current_scene.get_child(0).get_node("Sounds/foxySing").playing):
					get_tree().current_scene.get_child(0).get_node("Sounds/foxySing").play(0.0)
	else:
		foxySingTimer += delta

func doorPounding(delta):
	if(doorPoundingTimer >= 10):
		var random = RNG.randi_range(1, 50)
		doorPoundingTimer = 0
		if(random == 1):
			if(!get_tree().current_scene.get_child(0).get_node("Sounds/doorPounding").playing):
					get_tree().current_scene.get_child(0).get_node("Sounds/doorPounding").play(0.0)
	else:
		doorPoundingTimer += delta

func circusMusic(delta):
	if(circusMusicTimer >= 5):
		var random = RNG.randi_range(1, 30)
		circusMusicTimer = 0
		if(random == 1):
			if(!get_tree().current_scene.get_child(0).get_node("Sounds/circusMusic").playing):
					get_tree().current_scene.get_child(0).get_node("Sounds/circusMusic").play(0.0)
	else:
		circusMusicTimer += delta

func hallucinations(delta):
	if(!get_tree().current_scene.get_child(0).get_node("Sounds/hallucinationsSound").playing):
		get_tree().current_scene.get_child(0).get_node("HUD/hallucinations").stop()
	if(hallucinationsTimer >= 1):
		var random = RNG.randi_range(1, 1000)
		hallucinationsTimer = 0
		if(random == 1):
			if(!get_tree().current_scene.get_child(0).get_node("Sounds/hallucinationsSound").playing):
				get_tree().current_scene.get_child(0).get_node("Sounds/hallucinationsSound").play()
				get_tree().current_scene.get_child(0).get_node("HUD/hallucinations").play("hallucinations")
	else:
		hallucinationsTimer += delta
