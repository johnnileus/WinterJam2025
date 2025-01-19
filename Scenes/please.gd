extends Node3D
#https://www.youtube.com/watch?v=D3OWzdppBrU


var isRotating := false
var mouseOffset: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pickup"):
		isRotating = true
		mouseOffset = get_tree().root.get_mouse_position()
	elif Input.is_action_just_released("pickup"):
		isRotating = false
	if isRotating:
		mouseOffset = get_tree().root.get_mouse_position() - mouseOffset
		self.rotate_object_local(Vector3(0, 1, 0), mouseOffset.x * 0.01)
		mouseOffset = get_tree().root.get_mouse_position()
