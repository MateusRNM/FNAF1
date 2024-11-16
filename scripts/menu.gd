extends Control

@onready var newGameBtn = $newGameBTn
@onready var continueBtn = $continueBtn
@onready var transitionScene = preload("res://scenes/Transition.tscn")
@onready var nightInfoScene = preload("res://scenes/NightInfo.tscn")
@onready var customNight = preload("res://scenes/CustomNight.tscn")
@onready var music = $music
@onready var buttonSounds = $buttonSounds

func _ready():
	GameVars.loadData()
	

func _process(delta):
	if(Input.is_action_pressed("C") && Input.is_action_pressed("D") && Input.is_action_pressed("2")):
		GameVars.night = 5
		GameVars.night6Unlocked = true
		GameVars.cnUnlocked = true
		GameVars.stars = 2
		GameVars.saveData()
		
	if(GameVars.night6Unlocked):
		$night6Btn.visible = true
	
	if(GameVars.cnUnlocked):
		$customNight.visible = true
	for i in GameVars.stars:
		get_tree().current_scene.get_child(0).get_node("Star" + String.num_int64(i+1)).visible = true
	$nightContinue.text = "Night " + String.num_int64(GameVars.night)

func _on_new_game_b_tn_mouse_entered():
	newGameBtn.text = ">> New Game"
	buttonSounds.play()


func _on_new_game_b_tn_mouse_exited():
	newGameBtn.text = "   New Game"
	


func _on_continue_btn_mouse_entered():
	continueBtn.text = ">> Continue"
	$nightContinue.visible = true
	buttonSounds.play()


func _on_continue_btn_mouse_exited():
	continueBtn.text = "   Continue"
	$nightContinue.visible = false


func _on_new_game_b_tn_pressed():
	var save = FileAccess.open("user://save.data", FileAccess.WRITE)
	var data = {
		"night": 1,
		"stars": 0,
		"cnUnlocked": false,
		"night6Unlocked": false
	}
	
	if save:
		save.store_var(data)
		
	save.close()
	
	GameVars.loadData()
	
	get_parent().add_child(transitionScene.instantiate())
	queue_free()

func _on_music_finished():
	music.play()


func _on_continue_btn_pressed():
	get_parent().add_child(nightInfoScene.instantiate())
	queue_free()


func _on_night_6_btn_mouse_exited():
	$night6Btn.text = "   6th Night"


func _on_night_6_btn_mouse_entered():
	$night6Btn.text = ">> 6th Night"


func _on_night_6_btn_pressed():
	GameVars.night = 6
	get_parent().add_child(nightInfoScene.instantiate())
	queue_free()


func _on_custom_night_mouse_exited():
	$customNight.text = "   Custom Night"


func _on_custom_night_mouse_entered():
	$customNight.text = ">> Custom Night"


func _on_custom_night_pressed():
	get_parent().add_child(customNight.instantiate())
	queue_free()
