extends Control

@onready var cameras = [$CamHUD/Map/cam1a, $CamHUD/Map/cam1b, $CamHUD/Map/cam1c, $CamHUD/Map/cam5, 
						$CamHUD/Map/cam7, $CamHUD/Map/cam6, $CamHUD/Map/cam3, $CamHUD/Map/cam2a, 
						$CamHUD/Map/cam2b, $CamHUD/Map/cam4a, $CamHUD/Map/cam4b, "doorLeft", 
						"DoorRight"]
@export var selectedCamera = 0
@onready var camera = $Camera
@onready var cameraView = $cameraView
var cameraDirection = -1
var cameraSpeed = 60
var RNG = RandomNumberGenerator.new()
var cameraDisabledEffectFinished = false

func _ready():
	$Sounds/CameraMovingSound.play(0.0)
	selectedCamera = GameVars.lastCameraSelected
	camera.enabled = true
	$CamHUD/cameraEffect.visible = true
	$CamHUD/cameraEffect.play("effect")
	
func _process(delta):
	updateMap()
	updateCamera(delta)

func updateCamera(delta):
	camera.position.x += cameraDirection*cameraSpeed*delta
	if(camera.position.x <= camera.limit_left+350 || camera.position.x >= camera.limit_right-380):
		cameraDirection *= -1

func updateMap():
	for i in cameras.size()-2:
		if(i == selectedCamera):
			cameras[i].animation = "selected"
		else:
			cameras[i].animation = "unselected"
	
	if(IA.cameraDisabled):
		cameraView.visible = false
		if(!cameraDisabledEffectFinished):
			$CamHUD/cameraEffect.visible = true
			$CamHUD/cameraEffect.play("effect")
			cameraDisabledEffectFinished = true
		return
	else:
		cameraView.visible = true
	
	if(selectedCamera != 5):
		cameraView.visible = true
		$CamHUD/kitchenLabel.visible = false
		$Sounds/kitchen1.stop()
		$Sounds/kitchen2.stop()
		$Sounds/kitchen3.stop()
		$Sounds/kitchenFreddy.stop()
		
		
	cameraDisabledEffectFinished = false
	
	if(selectedCamera == 0):
		if(IA.bonnieLoc == 0 && IA.chicaLoc == 0 && IA.freddyLoc == 0):
			cameraView.animation = "ShowStage3"
		elif(IA.bonnieLoc == 0 && IA.freddyLoc == 0 && IA.chicaLoc != 0):
			cameraView.animation = "ShowStage2bonnie"
		elif(IA.bonnieLoc != 0 && IA.freddyLoc == 0 && IA.chicaLoc == 0):
			cameraView.animation = "ShowStage2chica"
		elif(IA.bonnieLoc != 0 && IA.freddyLoc == 0 && IA.chicaLoc != 0):
			cameraView.animation = "ShowStage1"
		else:
			cameraView.animation = "ShowStage0"
	elif(selectedCamera == 1):
		if(IA.bonnieLoc == 1 && IA.chicaLoc != 1 && IA.freddyLoc != 1):
			cameraView.animation = "diningAreaBonnie" + IA.BonnieLookingAtCamera
		elif(IA.bonnieLoc != 1 && IA.chicaLoc == 1 && IA.freddyLoc != 1):
			cameraView.animation = "diningAreaChica" + IA.ChicaLookingAtCamera
		elif(IA.bonnieLoc != 1 && IA.chicaLoc != 1 && IA.freddyLoc == 1):
			cameraView.animation = "diningAreaFreddy"
		else:
			cameraView.animation = "diningArea"
	elif(selectedCamera == 2):
		cameraView.animation = "piratesCove" + String.num_int64(IA.foxyStage)
	elif(selectedCamera == 3):
		if(IA.bonnieLoc == 3):
			cameraView.animation = "backStage" + IA.BonnieLookingAtCamera
		else:
			cameraView.animation = "backStage0"
	elif(selectedCamera == 4):
		if(IA.chicaLoc == 4 && IA.freddyLoc != 4):
			cameraView.animation = "bathroomsChica" + IA.ChicaLookingAtCamera
		elif(IA.chicaLoc != 4 && IA.freddyLoc == 4):
			cameraView.animation = "bathroomsFreddy"
		else:
			cameraView.animation = "bathrooms0"
	elif(selectedCamera == 5):
		cameraView.visible = false
		$CamHUD/kitchenLabel.visible = true
		if(IA.freddyLoc == 5):
			if($Sounds/kitchenFreddy.is_playing()):
				return
			$Sounds/kitchenFreddy.play()
		elif(IA.chicaLoc == 5):
			if($Sounds/kitchen1.is_playing() || $Sounds/kitchen2.is_playing() || $Sounds/kitchen3.is_playing()):
				return
			get_node("Sounds/kitchen" + String.num_int64(RNG.randi_range(1,  3))).play()
	elif(selectedCamera == 6):
		if(IA.bonnieLoc == 6):
			cameraView.animation = "supplyClosetBonnie"
		else:
			cameraView.animation = "supplyCloset"
	elif(selectedCamera == 7):
		if(IA.bonnieLoc == 7):
			cameraView.animation = "westHallBonnie"
		elif(IA.foxyStage == 3):
			cameraView.animation = "westHallFoxy"
		else:
			cameraView.animation = "westHall0"
			cameraView.play()
	elif(selectedCamera == 8):
		if(IA.bonnieLoc == 8):
			cameraView.animation = "westHallCornerBonnie1"
		else:
			cameraView.animation = "westHallCorner0"
	elif(selectedCamera == 9):
		if(IA.chicaLoc == 9):
			cameraView.animation = "eastHallChica" + IA.ChicaLookingAtCamera
		elif(IA.freddyLoc == 9):
			cameraView.animation = "eastHallFreddy"
		else:
			cameraView.animation = "eastHall0"
	elif(selectedCamera == 10):
		if(IA.chicaLoc == 10):
			cameraView.animation = "eastHallCornerChica"
		elif(IA.freddyLoc == 10):
			cameraView.animation = "eastHallCornerFreddy"
		else:
			cameraView.animation = "eastHallCorner0"

func changeCamera():
	$Sounds/CameraChangeSound.play(0.0)
	$CamHUD/cameraEffect.visible = true
	$CamHUD/cameraEffect.play("effect")
	GameVars.lastCameraSelected = selectedCamera

func _on_cam_1a_btn_pressed():
	selectedCamera = 0
	$CamHUD/Map/localName.text = "Show  Stage"
	changeCamera()


func _on_cam_1b_btn_pressed():
	selectedCamera = 1
	$CamHUD/Map/localName.text = "Dining  Area"
	changeCamera()


func _on_cam_1c_btn_pressed():
	selectedCamera = 2
	$CamHUD/Map/localName.text = "Pirate  Cove"
	changeCamera()


func _on_cam_5_btn_pressed():
	selectedCamera = 3
	changeCamera()
	$CamHUD/Map/localName.text = "Backstage"


func _on_cam_7_btn_pressed():
	selectedCamera = 4
	changeCamera()
	$CamHUD/Map/localName.text = "Restrooms"


func _on_cam_6_btn_pressed():
	selectedCamera = 5
	changeCamera()
	$CamHUD/Map/localName.text = "Kitchen"


func _on_cam_3_btn_pressed():
	selectedCamera = 6
	changeCamera()
	$CamHUD/Map/localName.text = "Supply  Closet"


func _on_cam_2a_btn_pressed():
	selectedCamera = 7
	changeCamera()
	$CamHUD/Map/localName.text = "West  Hall"


func _on_cam_2b_btn_pressed():
	selectedCamera = 8
	changeCamera()
	$CamHUD/Map/localName.text = "W.  Hall  Corner"


func _on_cam_4a_btn_pressed():
	selectedCamera = 9
	changeCamera()
	$CamHUD/Map/localName.text = "East  Hall"

func _on_cam_4b_btn_pressed():
	selectedCamera = 10
	changeCamera()
	$CamHUD/Map/localName.text = "E.  Hall  Corner"

func _on_camera_effect_animation_finished():
	$CamHUD/cameraEffect.visible = false
