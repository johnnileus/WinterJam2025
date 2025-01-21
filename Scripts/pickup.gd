extends Area3D

@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var realCam = get_tree().get_nodes_in_group("camera")[0]
@onready var fakeCam = get_tree().get_nodes_in_group("fakeCam")[0]
@onready var inventory = player.get_node("InventoryUI/Inventory")
@onready var CAMERA_ITEM = preload("res://Items/camera_item.tscn").instantiate()

var is_player_nearby: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("body_entered", Callable(self, "_on_trigger_entered"))
	self.connect("body_exited", Callable(self, "_on_trigger_exited"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_player_nearby and Input.is_action_just_pressed("pickup"):
		print_debug("picked up camera")
		realCam.visible = true
		realCam.hasCamera = true
		if fakeCam:
			fakeCam.queue_free()
		is_player_nearby = false
		inventory.add_item(CAMERA_ITEM, 1)
		

func _on_trigger_entered(body):
	if body.name == "Player":
		is_player_nearby = true
		$Prompt.visible = true

func _on_trigger_exited(body):
	if body.name == "Player":
		is_player_nearby = false
		$Prompt.visible = false
