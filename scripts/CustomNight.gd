extends Control

@onready var nightInfoScene = preload("res://scenes/NightInfo.tscn")

func _ready():
	IA.resetIA()

func _process(delta):
	$Buttons/freddyLabel.text = String.num_int64(IA.freddyLvl)
	$Buttons/bonnieLabel.text = String.num_int64(IA.bonnieLvl)
	$Buttons/chicaLabel.text = String.num_int64(IA.chicaLvl)
	$Buttons/foxyLabel.text = String.num_int64(IA.foxyLvl)


func _on_ready_btn_pressed():
	GameVars.night = 7
	get_parent().add_child(nightInfoScene.instantiate())
	queue_free()


func _on_freddy_plus_btn_pressed():
	if(IA.freddyLvl == 20):
		return
	IA.freddyLvl += 1


func _on_freddy_minus_btn_pressed():
	if(IA.freddyLvl == 0):
		return
	IA.freddyLvl -= 1


func _on_bonnie_plus_btn_pressed():
	if(IA.bonnieLvl == 20):
		return
	IA.bonnieLvl += 1


func _on_bonnie_minus_btn_pressed():
	if(IA.bonnieLvl == 0):
		return
	IA.bonnieLvl -= 1


func _on_chica_plus_btn_pressed():
	if(IA.chicaLvl == 20):
		return
	IA.chicaLvl += 1


func _on_chica_minus_btn_pressed():
	if(IA.chicaLvl == 0):
		return
	IA.chicaLvl -= 1

func _on_foxy_plus_btn_pressed():
	if(IA.foxyLvl == 20):
		return
	IA.foxyLvl += 1


func _on_foxy_minus_btn_pressed():
	if(IA.foxyLvl == 0):
		return
	IA.foxyLvl -= 1
