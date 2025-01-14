extends Node

var isRotating := false
var mouseOffset : Vector2
var sensitivity := 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interactWithObject"):
		isRotating = true
		mouseOffset = get_tree().root.get_mouse_position()
	elif Input.is_action_just_released("interactWithObject"):
		isRotating = false
	
	if isRotating:
		mouseOffset = get_tree().root.get_mouse_position() - mouseOffset
		$RotationAroundBase.rotation_degrees += Vector3(mouseOffset.y, mouseOffset.x, 0) * sensitivity
		mouseOffset = get_tree().root.get_mouse_position()
	pass
