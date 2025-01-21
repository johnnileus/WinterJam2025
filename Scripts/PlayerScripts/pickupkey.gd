extends Area3D

@onready var player = get_tree().get_nodes_in_group("player")[0]

@onready var inventory = player.get_node("CanvasLayer/Inventory")
@onready var CAMERA_ITEM = preload("res://Items/camera_item.tscn").instantiate()
@onready var KEY_ITEM = preload("res://Items/key_item.tscn").instantiate()
@onready var dangly_key = $"../danglyKey"

var hasKey = false

var is_player_nearby: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("body_entered", Callable(self, "_on_trigger_entered"))
	self.connect("body_exited", Callable(self, "_on_trigger_exited"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_player_nearby and Input.is_action_just_pressed("pickup"):
		print_debug("picked up camera")
		inventory.add_item(KEY_ITEM, 1)
		hasKey = true
		$Prompt.visible = false
		dangly_key.queue_free()
		

func _on_trigger_entered(body):
	if body.name == "Player" && !hasKey:
		is_player_nearby = true
		$Prompt.visible = true

func _on_trigger_exited(body):
	if body.name == "Player" && !hasKey:
		is_player_nearby = false
		$Prompt.visible = false
