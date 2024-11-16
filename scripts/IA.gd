extends Node

@export var bonnieLvl = 0
@export var bonnieLoc = 0
@export var bonnieAttacking = false
@export var bonnieInOffice = false
@export var BonnieLookingAtCamera : String

@export var chicaLvl = 0
@export var chicaLoc = 0
@export var chicaAttacking = false
@export var chicaInOffice = false
@export var ChicaLookingAtCamera : String

@export var freddyLvl = 0
@export var freddyLoc = 0
@export var freddyCountdown : Timer
@export var freddyCanMove = false
@export var freddyAttacking = false
@export var freddyJumpscareTimer = 0.0

@export var foxyLvl = 0
@export var foxyAttacking = false
@export var foxyStage = 0
@export var foxyTimer = 0.0
@export var foxyAttackTimer = 0.0
@export var foxyUnfreezeTime = 0.0
@export var foxyEnergyConsume = 1
@export var foxyFreezed = false

@export var cameraDisabled = false
var cameraDisabledTimer = 0.0

var freddyTimer = 0
var trioTimer = 0

var isDoorLeftOpen = true
var isDoorRightOpen = true

var RNG = RandomNumberGenerator.new()

func _process(delta):
	if(!GameVars.gameIsRunning):
		return
	else:
		if(get_tree().current_scene.get_child(0).jingleActivated):
			foxyAttacking = false
			freddyAttacking = false
			bonnieAttacking = false
			chicaAttacking = false
			return
	isDoorLeftOpen = get_tree().current_scene.get_child(0).isDoorLeftOpen if get_tree().current_scene.get_child(0) != null else false
	isDoorRightOpen = get_tree().current_scene.get_child(0).isDoorRightOpen if get_tree().current_scene.get_child(0) != null else false
	animatronicMovement(delta)
	if(cameraDisabled):
		if(cameraDisabledTimer >= 5.0):
			cameraDisabled = false
			cameraDisabledTimer = 0.0
		else:
			cameraDisabledTimer += delta

func resetIA():
	bonnieLvl = 0
	bonnieLoc = 0
	bonnieAttacking = false
	bonnieInOffice = false
	chicaLvl = 0
	chicaLoc = 0
	chicaAttacking = false
	chicaInOffice = false
	freddyLvl = 0
	freddyLoc = 0
	freddyCountdown = null
	freddyCanMove = false
	freddyAttacking = false
	freddyJumpscareTimer = 0.0
	foxyLvl = 0
	foxyAttacking = false
	foxyStage = 0
	foxyTimer = 0.0
	foxyAttackTimer = 0.0
	foxyUnfreezeTime = 0.0
	foxyEnergyConsume = 1
	foxyFreezed = false
	cameraDisabled = false
	cameraDisabledTimer = 0.0
	freddyTimer = 0
	trioTimer = 0
	isDoorLeftOpen = true
	isDoorRightOpen = true

func initializeIA():
	if(GameVars.night == 1):
		freddyLvl = 0
		bonnieLvl = 0
		foxyLvl = 0
		chicaLvl = 0
	elif(GameVars.night == 2):
		freddyLvl = 0
		bonnieLvl = 3
		foxyLvl = 1
		chicaLvl = 1
	elif(GameVars.night == 3):
		freddyLvl = 1
		bonnieLvl = 0
		foxyLvl = 2
		chicaLvl = 5
	elif(GameVars.night == 4):
		freddyLvl = RNG.randi_range(1, 2)
		bonnieLvl = 2
		foxyLvl = 6
		chicaLvl = 4
	elif(GameVars.night == 5):
		freddyLvl = 3
		bonnieLvl = 5
		foxyLvl = 5
		chicaLvl = 7
	elif(GameVars.night == 6):
		freddyLvl = 4
		bonnieLvl = 10
		foxyLvl = 16
		chicaLvl = 12

func animatronicMovement(delta):
	freddyTimer += delta
	trioTimer += delta
	bonnieMove()
	chicaMove()
	foxyMove(delta)
	if(GameVars.night >= 3):
		freddyMove()
	if(trioTimer >= 4.97):
		trioTimer = 0.0
	if(freddyTimer >= 3):
		freddyTimer = 0.0
		
func bonnieMove():
	if(trioTimer >= 4.97):
		if(bonnieLvl >= RNG.randi_range(1, 20)):
			if(get_tree().current_scene.get_child(0).cameraIsOpen && get_tree().current_scene.get_child(0).cameraInstance != null && !cameraDisabled):
				if(get_tree().current_scene.get_child(0).cameraInstance.selectedCamera == bonnieLoc):
					cameraDisabled = true
					
			get_tree().current_scene.get_child(0).get_node("Sounds/animatronicMoving").play(0.0)
			if(bonnieLoc == 0):
				var randRoom = RNG.randi_range(1, 2)
				if(randRoom == 1):
					bonnieLoc = 1
					BonnieLookingAtCamera = String.num_int64(RNG.randi_range(1, 2))
				else:
					bonnieLoc = 3
					BonnieLookingAtCamera = String.num_int64(RNG.randi_range(1, 2))
			elif(bonnieLoc == 1):
				var randRoom = RNG.randi_range(1, 2)
				if(randRoom == 1):
					bonnieLoc = 3
					BonnieLookingAtCamera = String.num_int64(RNG.randi_range(1, 2))
				else:
					bonnieLoc = 7
			elif(bonnieLoc == 3):
				var randRoom = RNG.randi_range(1, 2)
				if(randRoom == 1):
					bonnieLoc = 1
				else:
					bonnieLoc = 7
			elif(bonnieLoc == 7):
				var randRoom = RNG.randi_range(1, 2)
				if(randRoom == 1):
					bonnieLoc = 6
				else:
					bonnieLoc = 8
			elif(bonnieLoc == 6):
				bonnieLoc = 7
			elif(bonnieLoc == 8):
				bonnieLoc = 11
				get_tree().current_scene.get_child(0).isLeftLightOn = false
				get_tree().current_scene.get_child(0).usage -= 1
				get_tree().current_scene.get_child(0).get_node("Sounds/lightSound").stop()
			elif(bonnieLoc == 11):
				if(!isDoorLeftOpen):
					var randRoom = RNG.randi_range(1, 2)
					if(randRoom == 1):
						bonnieLoc = 1
						BonnieLookingAtCamera = String.num_int64(RNG.randi_range(1, 2))
						get_tree().current_scene.get_child(0).animatronicSoundPlayedL = false
			
			if(get_tree().current_scene.get_child(0).cameraIsOpen && get_tree().current_scene.get_child(0).cameraInstance != null && !cameraDisabled):
				if(get_tree().current_scene.get_child(0).cameraInstance.selectedCamera == bonnieLoc):
					cameraDisabled = true

func chicaMove():
	if(trioTimer >= 4.97):
		if(chicaLvl >= RNG.randi_range(1, 20)):
			if(get_tree().current_scene.get_child(0).cameraIsOpen && get_tree().current_scene.get_child(0).cameraInstance != null && !cameraDisabled):
				if(get_tree().current_scene.get_child(0).cameraInstance.selectedCamera == chicaLoc):
					cameraDisabled = true
					
			get_tree().current_scene.get_child(0).get_node("Sounds/animatronicMoving").play(0.0)
			if(chicaLoc == 0):
				ChicaLookingAtCamera = String.num_int64(RNG.randi_range(1, 2))
				chicaLoc = 1
			elif(chicaLoc == 1):
				var randRoom = RNG.randi_range(1, 3)
				if(randRoom == 1):
					chicaLoc = 4
					ChicaLookingAtCamera = String.num_int64(RNG.randi_range(1, 2))
				elif(randRoom == 2):
					chicaLoc = 9
					ChicaLookingAtCamera = String.num_int64(RNG.randi_range(1, 2))
				else:
					chicaLoc = 5
			elif(chicaLoc == 4):
				chicaLoc = 1
			elif(chicaLoc == 5):
				chicaLoc = 1
			elif(chicaLoc == 9):
				chicaLoc = 10
			elif(chicaLoc == 10):
				chicaLoc = 12
				get_tree().current_scene.get_child(0).isRightLightOn = false
				get_tree().current_scene.get_child(0).usage -= 1
				get_tree().current_scene.get_child(0).get_node("Sounds/lightSound").stop()
			elif(chicaLoc == 12):
				if(!isDoorRightOpen):
					var randRoom = RNG.randi_range(1, 2)
					if(randRoom == 1):
						chicaLoc = 1
						ChicaLookingAtCamera = String.num_int64(RNG.randi_range(1, 2))
						get_tree().current_scene.get_child(0).animatronicSoundPlayedR = false
			
			if(get_tree().current_scene.get_child(0).cameraIsOpen && get_tree().current_scene.get_child(0).cameraInstance != null && !cameraDisabled):
				if(get_tree().current_scene.get_child(0).cameraInstance.selectedCamera == chicaLoc):
					cameraDisabled = true

func freddyMove():
	var cameraSelected = -1
	if get_tree().current_scene.get_child(0).cameraInstance != null:
		cameraSelected = get_tree().current_scene.get_child(0).cameraInstance.selectedCamera
	
	if(freddyCountdown != null && cameraSelected == freddyLoc):
		freddyCountdown.stop()
		freddyCountdown.start(0.0)
	
	if(freddyCanMove):
		freddyTimer = 0.0
		if(!get_tree().current_scene.get_child(0).cameraIsOpen || get_tree().current_scene.get_child(0).cameraIsOpen && cameraSelected != freddyLoc && freddyLoc == 12):
			freddyCanMove = false
			if(cameraSelected == freddyLoc):
				cameraDisabled = true
			if(freddyLoc == 0):
				freddyLoc = 1
			elif(freddyLoc == 1):
				freddyLoc = 4
			elif(freddyLoc == 4):
				freddyLoc = 5
			elif(freddyLoc == 5):
				freddyLoc = 9
			elif(freddyLoc == 9):
				freddyLoc = 10
			elif(freddyLoc == 10):
				freddyLoc = 12
			elif(freddyLoc == 12):
				if(!get_tree().current_scene.get_child(0).isDoorRightOpen):
					freddyLoc = 9
				else:
					if(get_tree().current_scene.get_child(0).cameraIsOpen):
						if(cameraSelected != 10):
							freddyAttacking = true
							
			if(freddyLoc == 12):
				get_tree().current_scene.get_child(0).get_node("Sounds/freddyMovingToOffice").play()
			else:
				get_tree().current_scene.get_child(0).get_node("Sounds/freddyMoving" + String.num_int64(RNG.randi_range(1, 3))).play()
			
			if(cameraSelected == freddyLoc):
				cameraDisabled = true
		return
		
	if(freddyTimer >= 3):
		if(freddyCountdown == null):
			var time = 16.67 - (1.67*freddyLvl)
			time = 0 if time < 0.01 else time
			var timer = Timer.new()
			timer.wait_time = time
			timer.timeout.connect(freddyTimerFinished)
			get_tree().current_scene.get_child(0).add_child(timer)
			freddyCountdown = timer
			timer.start()
			
func freddyTimerFinished():
	freddyCanMove = true
	freddyCountdown.queue_free()

func foxyMove(delta):
	if(foxyFreezed):
		if(foxyTimer >= foxyUnfreezeTime):
			foxyUnfreezeTime = 0.0
			foxyTimer = 0.0
			foxyFreezed = false
		foxyTimer += delta
		return
		
		
	if(get_tree().current_scene.get_child(0).cameraIsOpen && !foxyFreezed):
		foxyFreezed = true
		foxyUnfreezeTime = RNG.randf_range(0.5, 10.5)
		return
		
	if(foxyStage == 2):
		if(get_tree().current_scene.get_child(0).isLeftLightOn):
			foxyStage = 3
			foxyRun()
		if(foxyAttackTimer >= 25):
			foxyStage = 3
			foxyRun()
		foxyAttackTimer += delta
		return
	
	if(trioTimer >= 4.97):
		if(foxyLvl >= RNG.randi_range(1, 20)):
			if(foxyStage < 2):
				foxyStage += 1

func foxyRun():
	foxyAttackTimer = 0.0
	foxyUnfreezeTime = 0.0
	foxyTimer = 0.0
	get_tree().current_scene.get_child(0).get_node("Sounds/foxyRunning1").play()
