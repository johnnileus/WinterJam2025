extends Node3D

@onready var sub_viewport = $SubViewport
@onready var camera_3d = $SubViewport/Camera3D
@onready var item_pivot = $"../pivot/cameraNode/itemPivot"
@onready var close_pivot = $"../pivot/cameraNode/closePivot"
@onready var spookyshadow = $spookyshadow

var counter = 0

@onready var flash = $flash
@onready var flash_noise = $flashNoise

@onready var flash_timer = $flashTimer
@onready var render_delay = $renderDelay

@onready var visionLight = preload("res://Scenes/vision_light.tscn")

var active = false
var onCooldown = false
var hasCamera = false

# Called when the node enters the scene tree for the first time.
func _ready():
	flash.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var newPos
	if Input.is_action_pressed("rightClick"):
		active = true
		newPos = close_pivot.global_position
		
	else:
		active = false
		newPos = lerp(global_position, item_pivot.global_position, 0.1)
		newPos = item_pivot.global_position
		
		
	
	global_rotation.y = item_pivot.global_rotation.y
	camera_3d.global_rotation.y = item_pivot.global_rotation.y

	global_position = newPos
	camera_3d.global_position = newPos - camera_3d.basis.z * Vector3(0,0,0.1)


	if active && !onCooldown:
		if Input.is_action_just_pressed("takePicture") and hasCamera:
			flash.visible = true
			flash_timer.start()
			counter+= 1
			if counter % 3 == 0:
				spookyshadow.visible = true


			
			
			

func _on_flash_length_timeout():
	sub_viewport.render_target_update_mode = sub_viewport.UPDATE_DISABLED
	flash.visible = false
	var newLight = visionLight.instantiate()
	newLight.rotation = global_rotation
	newLight.position = global_position
	get_tree().root.add_child(newLight)
	flash_noise.play()
	spookyshadow.visible = false
	
	onCooldown = true
	render_delay.start()

func _on_render_delay_timeout():
	sub_viewport.render_target_update_mode = sub_viewport.UPDATE_ALWAYS
	onCooldown = false
