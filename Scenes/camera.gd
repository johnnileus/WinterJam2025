extends Node3D

@onready var sub_viewport = $SubViewport
@onready var camera_3d = $SubViewport/Camera3D
@onready var item_pivot = $"../Model/itemPivot"
@onready var visionLight = preload("res://Scenes/vision_light.tscn")
@onready var flash = $flash

@onready var flash_timer = $flashTimer
@onready var render_delay = $renderDelay

# Called when the node enters the scene tree for the first time.
func _ready():
	flash.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = item_pivot.global_position
	global_rotation.y = item_pivot.global_rotation.y
	camera_3d.global_position = item_pivot.global_position
	camera_3d.global_rotation.y = item_pivot.global_rotation.y
	
	if Input.is_action_just_pressed("takePicture"):
		flash.visible = true
		flash_timer.start()
		

func _on_flash_length_timeout():
	sub_viewport.render_target_update_mode = sub_viewport.UPDATE_DISABLED
	flash.visible = false
	var newLight = visionLight.instantiate()
	newLight.rotation = global_rotation
	newLight.position = global_position
	get_tree().root.add_child(newLight)
	render_delay.start()


func _on_render_delay_timeout():
	sub_viewport.render_target_update_mode = sub_viewport.UPDATE_ALWAYS
