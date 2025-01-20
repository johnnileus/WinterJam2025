extends Node3D


var entered_pin = ""          # Tracks the currently entered PIN
var correct_pin = "6318"      # The correct PIN
var max_length = 4

@onready var display = $Label3D
@onready var keys: Node3D = $Keys

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in keys.get_children():
		if child is StaticBody3D:
			child.connect("_on_button_press", Callable(self, "_on_button_input"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_input(button: RigidBody3D, event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var key_value = button.get_meta("key_value")
		if key_value:
			print("Button pressed:", key_value)
			_on_button_press(key_value)
		
func _on_button_press(key_value: String) -> void:
	if entered_pin.length() < max_length:
		entered_pin += key_value
		display.text = entered_pin
	else:
		print("PIN complete")

func check_pin() -> void:
	if entered_pin == correct_pin:
		print_debug("You Win")
	else:
		print_debug("denied")
	reset_pin()

func reset_pin() -> void:
	entered_pin = ""
	display.text = ""




func _on__input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	
	pass # Replace with function body.
