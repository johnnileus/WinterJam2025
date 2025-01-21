extends Area3D

@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var playerCam = player.get_node("pivot/cameraNode/camera")
#@onready var keypadCam = $Camera3D
@onready var door: Node3D = $"../../Sketchfab_Scene"
@onready var keypad: Node3D = $".."



##  i deleted camera it was breaking stuff, sowwy :3



var is_player_nearby: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("body_entered", Callable(self, "_on_trigger_entered"))
	self.connect("body_exited", Callable(self, "_on_trigger_exited"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_player_nearby and Input.is_action_just_pressed("pickup"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.lockedMovement = true
		#keypadCam.current = true
		if door == null:
			return
		door.queue_free()
	elif is_player_nearby and Input.is_action_just_pressed("Escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		player.lockedMovement = false
		playerCam.current = true
		keypad.queue_free()

func _on_trigger_entered(body):
	if body.name == "Player":
		is_player_nearby = true
		$Prompt.visible = true

func _on_trigger_exited(body):
	if body.name == "Player":
		is_player_nearby = false
		$Prompt.visible = false
