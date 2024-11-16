extends Control

@onready var playerCamera = $PlayerCamera
@onready var buttonsLeft = $buttonsLeft
@onready var buttonsRight = $buttonsRight
@onready var posterSound = $Sounds/posterSound
@onready var ambientSound = $Sounds/ambientSound
@onready var doorSound = $Sounds/doorSound
@onready var lightSound = $Sounds/lightSound
@onready var doorLeft = $doorLeft
@onready var doorRight = $doorRight
@onready var room = $room
@onready var cameraBtnSprite = $HUD/cameraBtn/sprite
@onready var cameraAnim = $HUD/CameraAnim
@onready var usageSprite = $HUD/usageSprite
const Camera = preload("res://scenes/Camera.tscn")
const GameOverScreen = preload("res://scenes/GameOver.tscn")
const nightInfoScreen = preload("res://scenes/NightInfo.tscn")
const WinScreen = preload("res://scenes/WinScreen.tscn")
@onready var animatronicsLoudsEnteringOffice = [$Sounds/gemidoAnimatronic1, $Sounds/gemidoAnimatronic2, $Sounds/gemidoAnimatronic3]
@export var power = 99.9
@export var usage = 1.0
var CameraSpeed = 15
@export var isDoorLeftOpen = true
@export var isDoorRightOpen = true
@export var animatronicSoundPlayedL = false
@export var animatronicSoundPlayedR = false
@export var isLeftLightOn = false
@export var isRightLightOn = false
@export var cameraIsOpen = false
var cameraInstance : Control
var powerConsumeNightDelta = 0.0
var powerConsume = powerConsumeNightDelta*usage
var powerConsumeTimer = 0.0
var timerNight = 0.0
var time = 0
var callPlaying : AudioStreamPlayer
var RNG = RandomNumberGenerator.new()
var timeInCamera = 0.0
var animatronicLoudPlaying : AudioStreamPlayer
var jumpscared = false
var winMusicPlayed = 0

@export var jingleActivated = false
var jingleTimerTotal = 0
var jingleTimer = 0
var jingleAttack = false
var jinglePlaying = false
var jingleFinal = false

func _ready():
	$HUD/nightLabel.text = "Night " + String.num_int64(GameVars.night)
	if(GameVars.night != 7):
		IA.resetIA()
		IA.initializeIA()
	if(GameVars.night == 1):
		powerConsumeNightDelta = 0.1
	elif(GameVars.night == 2):
		powerConsumeNightDelta = 0.116
	elif(GameVars.night == 3):
		powerConsumeNightDelta = 0.119
	elif(GameVars.night == 4):
		powerConsumeNightDelta = 0.125
	else:
		powerConsumeNightDelta = 0.131
	phoneGuy()
	GameVars.gameIsRunning = true

func phoneGuy():
	var rng = RNG.randi_range(1, 100)
	if(rng >= 1 && rng <= 15):
		callPlaying = $Sounds/callmeme
		callPlaying.play()
		return
		
	if(GameVars.night == 1):
		callPlaying = $Sounds/calln1
		callPlaying.play()
	elif(GameVars.night == 2):
		callPlaying = $Sounds/calln2
		callPlaying.play()
	elif(GameVars.night == 3):
		callPlaying = $Sounds/calln3
		callPlaying.play()
	elif(GameVars.night == 4):
		callPlaying = $Sounds/calln4
		callPlaying.play()
	elif(GameVars.night == 5):
		callPlaying = $Sounds/calln5
		callPlaying.play()
	else:
		callPlaying = $Sounds/calln5
		$HUD/muteBtnSprite.visible = false
		

func _process(delta):
	if(Input.is_action_pressed("C") && Input.is_action_pressed("D") && Input.is_action_pressed("2")):
		time = 6
	if(jingleActivated):
		jingle(delta)
	if(!GameVars.gameIsRunning && jumpscared):
		get_parent().add_child(GameOverScreen.instantiate())
		queue_free()
		return
	
	if(time == 6):
		GameVars.gameIsRunning = false
		for i in $Sounds.get_child_count():
			if(winMusicPlayed == 0):
				$Sounds.get_child(i).stop()
		
		if(winMusicPlayed == 0):
			$Sounds/winMusic.playing = true
			winMusicPlayed += 1
		
		if($Sounds/winMusic.get_playback_position() >= 4 && winMusicPlayed == 1):
				$Sounds/comemoracao.play()
				winMusicPlayed += 1
		
		if($HUD/FinalScreen.modulate.a < 254.99):
			$HUD/FinalScreen.modulate.a += 6
			return
		
		$HUD/FinalScreen/label5.position.y -= 0.4 if $HUD/FinalScreen/label5.position.y > 225 else 0
		$HUD/FinalScreen/label6.position.y -= 0.4 if $HUD/FinalScreen/label6.position.y > 285 else 0
		return
	
	if(!cameraIsOpen && !IA.foxyAttacking && !IA.bonnieAttacking && !IA.chicaAttacking && !IA.freddyAttacking):
		moveCamera(delta)
	if(callPlaying.playing):
		if(callPlaying.get_playback_position() >= 16):
			$HUD/muteBtnSprite.visible = false
	updateRoomSprites(delta)
	updatePower()
	updateTime()
	EasterEggs.verifyEGs(delta)
	powerConsumeTimer += delta
	timerNight += delta

func updateTime():
	if(timerNight >= 86.17):
		time += 1
		$HUD/timeLabel.text = String.num_int64(time) + " AM"
		if(time == 2):
			IA.bonnieLvl += 1
		elif(time == 3 || time == 4):
			IA.bonnieLvl += 1
			IA.chicaLvl += 1
			IA.foxyLvl += 1
		timerNight = 0.0

func updatePower():
	if(jingleActivated):
		return
	if(power <= 0):
		power = 0
		$HUD/PowerLabel.text = "Power   Left:  " + String.num_int64(power) + " %"
		jingleInit()
		return
	powerConsume = powerConsumeNightDelta*usage
	
	if(powerConsumeTimer >= 1.0):
		power -= powerConsume
		powerConsumeTimer = 0.0
	$HUD/PowerLabel.text = "Power   Left:  " + String.num_int64(power) + " %"

func moveCamera(delta):
	playerCamera.position.x += (get_viewport().get_mouse_position().x - playerCamera.position.x) * CameraSpeed * delta

func updateRoomSprites(delta):
	if(jumpscared):
		if($Sounds/jumpscare.get_playback_position() >= 3):
			GameVars.gameIsRunning = false
	if(jingleActivated):
		if(jingleAttack):
			room.modulate.r = 1
			room.modulate.g = 1
			room.modulate.b = 1
			playerCamera.position.x = 575
			room.animation = "jingleAttack"
			room.play()
			return
		if(jinglePlaying):
			room.animation = "jingleFreddy"
			room.play()
			return
		room.animation = "jingle"
		return
	
	if(isDoorLeftOpen && isLeftLightOn):
		buttonsLeft.animation = "openOn"
	elif(isDoorLeftOpen && !isLeftLightOn):
		buttonsLeft.animation = "openOff"
	elif(!isDoorLeftOpen && isLeftLightOn):
		buttonsLeft.animation = "closeOn"
	elif(!isDoorLeftOpen && !isLeftLightOn):
		buttonsLeft.animation = "closeOff"
	
	if(isDoorRightOpen && isRightLightOn):
		buttonsRight.animation = "openOn"
	elif(isDoorRightOpen && !isRightLightOn):
		buttonsRight.animation = "openOff"
	elif(!isDoorRightOpen && isRightLightOn):
		buttonsRight.animation = "closeOn"
	elif(!isDoorRightOpen && !isRightLightOn):
		buttonsRight.animation = "closeOff"
		
	usageSprite.animation = String.num_int64(usage)
	
	if(IA.bonnieLoc == 11 && isDoorLeftOpen && cameraIsOpen && !IA.bonnieInOffice):
		IA.bonnieInOffice = true
		animatronicLoudPlaying = animatronicsLoudsEnteringOffice[RNG.randi_range(0, animatronicsLoudsEnteringOffice.size()-1)]
		animatronicLoudPlaying.play(0.0)
	
	if(IA.chicaLoc == 12 && isDoorRightOpen && cameraIsOpen && !IA.chicaInOffice):
		IA.chicaInOffice = true
		animatronicLoudPlaying = animatronicsLoudsEnteringOffice[RNG.randi_range(0, animatronicsLoudsEnteringOffice.size()-1)]
		animatronicLoudPlaying.play(0.0)
	
	if(IA.bonnieInOffice && !animatronicLoudPlaying.playing && cameraIsOpen):
		IA.bonnieAttacking = true
	
	if(IA.chicaInOffice && !animatronicLoudPlaying.playing && cameraIsOpen):
		IA.chicaAttacking = true
	
	if(IA.freddyAttacking):
		if(IA.freddyJumpscareTimer >= 1):
			IA.freddyJumpscareTimer = 0
			if(RNG.randi_range(1, 5) == 1):
				if(cameraInstance != null):
					cameraInstance.queue_free()
				room.animation = "freddyJumpscare1"
				isLeftLightOn = false
				isRightLightOn = false
				$fan.visible = false
				$buttonsRight.visible = false
				doorLeft.visible = false
				doorRight.visible = false
				room.play()
				playerCamera.position.x = 525
				ambientSound.stop()
				callPlaying.stop()
				lightSound.stop()
				$HUD/cameraBtn.visible = false
				if(!jumpscared):
					$Sounds/jumpscare.play()
					jumpscared = true
				return
		IA.freddyJumpscareTimer += delta
	
	if(IA.bonnieAttacking && !cameraIsOpen):
		room.animation = "bonnieJumpscare"
		isLeftLightOn = false
		isRightLightOn = false
		$fan.visible = false
		$doorRight.visible = false
		doorLeft.visible = false
		room.play()
		playerCamera.position.x = 525
		ambientSound.stop()
		callPlaying.stop()
		lightSound.stop()
		$HUD/cameraBtn.visible = false
		if(!jumpscared):
			$Sounds/jumpscare.play()
			jumpscared = true
		return
	elif(IA.bonnieAttacking && cameraIsOpen):
		if(timeInCamera >= 30):
			cameraInstance.queue_free()
			cameraIsOpen = false
			room.animation = "bonnieJumpscare"
			isLeftLightOn = false
			isRightLightOn = false
			$fan.visible = false
			$doorRight.visible = false
			doorLeft.visible = false
			room.play()
			playerCamera.position.x = 525
			ambientSound.stop()
			callPlaying.stop()
			lightSound.stop()
			$HUD/cameraBtn.visible = false
			if(!jumpscared):
				$Sounds/jumpscare.play()
				jumpscared = true
			return
		else:
			timeInCamera += delta
		
	if(IA.chicaAttacking && !cameraIsOpen):
		room.animation = "chicaJumpscare"
		room.play()
		isLeftLightOn = false
		isRightLightOn = false
		$fan.visible = false
		doorLeft.visible = false
		playerCamera.position.x = 525
		ambientSound.stop()
		callPlaying.stop()
		lightSound.stop()
		$HUD/cameraBtn.visible = false
		if(!jumpscared):
			$Sounds/jumpscare.play()
			jumpscared = true
		return
	elif(IA.chicaAttacking && cameraIsOpen):
		if(timeInCamera >= 30):
			cameraInstance.queue_free()
			cameraIsOpen = false
			room.animation = "chicaJumpscare"
			isLeftLightOn = false
			isRightLightOn = false
			$fan.visible = false
			doorLeft.visible = false
			room.play()
			playerCamera.position.x = 525
			ambientSound.stop()
			callPlaying.stop()
			lightSound.stop()
			$HUD/cameraBtn.visible = false
			if(!jumpscared):
				$Sounds/jumpscare.play()
				jumpscared = true
			return
		else:
			timeInCamera += delta
	
	
	if(IA.bonnieLoc == 11 && isLeftLightOn):
		room.animation = "bonnieInDoor"
		return
		
	if(IA.chicaLoc == 12 && isRightLightOn):
		room.animation = "chicaInDoor"
		return
	
	if(IA.foxyAttacking):
		return
	
	if(room.animation == "freddyJumpscare1"):
		return
	
	if(isRightLightOn):
		room.animation = "lightRight"
		room.play()
	elif(isLeftLightOn):
		room.animation = "lightLeft"
		room.play()
	else:
		room.animation = "noLight"
		room.play()

func jingleInit():
	for i in $Sounds.get_child_count():
		$Sounds.get_child(i).stop()
	jingleActivated = true
	$HUD.visible = false
	$fan.visible = false
	$buttonsLeft.visible = false
	$buttonsRight.visible = false
	$doorLeft.visible = false
	$doorRight.visible = false
	$Sounds/powerDown.play()
	
	if(!isDoorLeftOpen):
		doorLeft.animation = "opening"
		doorLeft.play()
	
	if(!isDoorRightOpen):
		doorRight.animation = "opening"
		doorRight.play()
	
func jingle(delta):
	if(cameraInstance != null):
		cameraInstance.queue_free()
		
	if(lightSound.get_playback_position() >= 0.5):
		lightSound.stop()
		room.modulate.r = 0.03
		room.modulate.g = 0.03
		room.modulate.b = 0.03
	
	jingleTimer += delta
	jingleTimerTotal += delta
	
	if(jingleFinal):
		if(jingleTimer >= 2):
			jingleTimer = 0
			if(RNG.randi_range(1, 100) <= 20 || jingleTimerTotal >= 20):
				jingleAttack = true
				GameVars.gameIsRunning = false
				$Sounds/jumpscare.play()
		return
	
	if(jingleTimer >= 5):
		jingleTimer = 0
		if(RNG.randi_range(1, 100) <= 20):
			if(!jinglePlaying):
				jingleTimerTotal = 0
				jinglePlaying = true
				$Sounds/musicBox.play()
			else:
				$Sounds/musicBox.stop()
				jingleFinal = true
				$Sounds/lightSound.play()
	
	if(jingleTimerTotal >= 20):
		if(!jinglePlaying):
			jinglePlaying = true
			$Sounds/musicBox.play()

func _on_door_btn_left_pressed():
	if(!GameVars.gameIsRunning):
		return
	if(IA.bonnieInOffice):
		$Sounds/buttonError.play(0.0)
		return
	if(doorLeft.is_playing()):
		return
	isDoorLeftOpen = !isDoorLeftOpen
	doorSound.play(0.0)
	if(isDoorLeftOpen):
		doorLeft.animation = "opening"
		doorLeft.play()
		usage -= 1
	else:
		doorLeft.animation = "closing"
		doorLeft.play()
		usage += 1


func _on_light_btn_left_pressed():
	if(!GameVars.gameIsRunning):
		return
	if(IA.bonnieInOffice):
		$Sounds/buttonError.play(0.0)
		return
	isLeftLightOn = !isLeftLightOn
	if(IA.bonnieLoc == 11 && isLeftLightOn && !animatronicSoundPlayedL):
		$Sounds/animatronicInWindowSound.play()
		animatronicSoundPlayedL = true
		
	if(isRightLightOn):
		usage -= 1
		isRightLightOn = false
	if(isLeftLightOn):
		lightSound.play(0.0)
		usage += 1
	else:
		lightSound.stop()
		usage -= 1


func _on_door_btn_right_pressed():
	if(!GameVars.gameIsRunning):
		return
	if(IA.chicaInOffice || IA.freddyAttacking):
		$Sounds/buttonError.play(0.0)
		return
	if(doorRight.is_playing()):
		return
	isDoorRightOpen = !isDoorRightOpen
	doorSound.play(0.0)
	if(isDoorRightOpen):
		doorRight.animation = "opening"
		doorRight.play()
		usage -= 1
	elif(!isDoorRightOpen):
		doorRight.animation = "closing"
		doorRight.play()
		usage += 1

func _on_light_btn_right_pressed():
	if(!GameVars.gameIsRunning):
		return
	if(IA.chicaInOffice || IA.freddyAttacking):
		$Sounds/buttonError.play(0.0)
		return
	isRightLightOn = !isRightLightOn
	if(IA.chicaLoc == 12 && isRightLightOn && !animatronicSoundPlayedR):
		$Sounds/animatronicInWindowSound.play()
		animatronicSoundPlayedR = true
		
	if(isLeftLightOn):
		usage -= 1
		isLeftLightOn = false
	if(isRightLightOn):
		lightSound.play(0.0)
		usage += 1
	else:
		lightSound.stop()
		usage -= 1

func _on_poster_pressed():
	posterSound.play()

func _on_ambient_sound_finished():
	ambientSound.play()

func _on_camera_anim_animation_finished():
	cameraBtnSprite.visible = true
	cameraAnim.visible = false
	cameraIsOpen = !cameraIsOpen
	if(cameraIsOpen):
		cameraInstance = Camera.instantiate()
		$HUD/CAM.add_child(cameraInstance, false, Node.INTERNAL_MODE_FRONT)
		playerCamera.enabled = false
		
func _on_camera_btn_mouse_entered():
	if(cameraAnim.is_playing() || !GameVars.gameIsRunning):
		return
	if(!cameraIsOpen):
		cameraAnim.visible = true
		cameraBtnSprite.visible = false
		cameraAnim.animation = "opening"
		cameraAnim.play()
		ambientSound.volume_db = -12
		usage += 1
		if(isLeftLightOn || isRightLightOn):
			usage -= 1
			isLeftLightOn = false
			isRightLightOn = false
			lightSound.stop()
	else:
		playerCamera.enabled = true
		cameraAnim.visible = true
		cameraAnim.animation = "closing"
		cameraAnim.play()
		cameraInstance.queue_free()
		ambientSound.volume_db = -3
		usage -= 1
	$Sounds/takeCameraSound.play()


func _on_mute_btn_pressed():
	$HUD/muteBtnSprite.visible = false
	callPlaying.stop()

func _on_foxy_running_2_finished():
	if(isDoorLeftOpen):
		IA.foxyAttacking = true
		room.animation = "foxyJumpscare"
		room.play()
		playerCamera.position.x = 500
		if(cameraIsOpen):
			cameraInstance.queue_free()
		cameraIsOpen = false
		doorLeft.visible = false
		ambientSound.stop()
		callPlaying.stop()
		lightSound.stop()
		isLeftLightOn = false
		isRightLightOn = false
		$HUD/cameraBtn.visible = false
		if(!jumpscared):
			$Sounds/jumpscare.play()
			jumpscared = true
	else:
		$Sounds/foxyKnockingInDoor.play()
		power -= IA.foxyEnergyConsume
		IA.foxyEnergyConsume += 5


func _on_foxy_running_1_finished():
	$Sounds/foxyRunning2.play()


func _on_foxy_knocking_in_door_finished():
	if(cameraInstance != null):
		if(cameraInstance.selectedCamera == 2):
			IA.cameraDisabled = true
	IA.foxyStage = 0


func _on_win_music_finished():
	if(GameVars.night == 5):
		GameVars.stars = 1 if GameVars.stars == 0 else GameVars.stars
		GameVars.night6Unlocked = true
	elif(GameVars.night == 6):
		GameVars.stars = 2 if GameVars.stars == 1 else GameVars.stars
		GameVars.cnUnlocked = true
	elif(GameVars.night == 7):
		GameVars.stars = 3
	
	if(GameVars.night < 5):
		get_parent().add_child(nightInfoScreen.instantiate())
	else:
		var instance = WinScreen.instantiate()
		instance.nightCompleted = GameVars.night
		get_parent().add_child(instance)
	
	if(GameVars.night >= 6):
		GameVars.night = 5
	
	GameVars.night += 1 if GameVars.night < 5 else 0
	GameVars.saveData()
	queue_free()


func _on_room_animation_finished():
	if($room.animation == "jingleAttack"):
		jumpscared = true
		$Sounds/jumpscare.stop()


func _on_hallucinations_animation_finished():
	$HUD/hallucinations.animation = "NA"
	$Sounds/hallucinationsSound.stop()
