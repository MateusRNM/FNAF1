extends Node

@export var night = 1
@export var cnUnlocked = false
@export var stars = 0
@export var night6Unlocked = false

@export var gameIsRunning = false
@export var lastCameraSelected = 0


func loadData():
	var save = FileAccess.open("user://save.data", FileAccess.READ)
	if save:
		var data = save.get_var()
		night = data["night"]
		cnUnlocked = data["cnUnlocked"]
		stars = data["stars"]
		night6Unlocked = data["night6Unlocked"]
	save.close()

func saveData():
	var save = FileAccess.open("user://save.data", FileAccess.WRITE)
	var data = {
		"night": night,
		"stars": stars,
		"cnUnlocked": cnUnlocked,
		"night6Unlocked": night6Unlocked
	}
	if save:
		save.store_var(data)
	save.close()
