extends Node

@onready var label1 = $"TextureRect/Text 1"
@onready var label2 = $"TextureRect/Text 2"
@onready var button = $"TextureRect/Button"
@onready var panel = $TextureRect
@onready var text_trigger_area = $Area3D
@onready var player = get_tree().get_nodes_in_group("player")[0]

var current_label_index = 0
var draw_text_speed = 0
var text_trigger = false
var char_limit = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.connect("pressed", Callable(self, "_on_button_pressed"))
	reset_labels()
	text_trigger_area.connect("body_entered", Callable(self, "_on_trigger_entered"))
	button.disabled = true

func reset_labels():
	if current_label_index == 0:
		label1.visible = true
		label2.visible = false
		draw_text_speed = 0
		#label1.visible_characters = draw_text_speed 
		char_limit = label1.text.length()
	elif current_label_index == 1:
		label1.visible = false
		label2.visible = true
		draw_text_speed = 0
		#label2.visible_characters = draw_text_speed
		char_limit = label2.text.length()
		
func _show_char():
	if draw_text_speed < char_limit and text_trigger:
		draw_text_speed += 1
		if current_label_index == 0:
			label1.visible_characters = draw_text_speed
		elif current_label_index == 1:
			label2.visible_characters = draw_text_speed
	elif draw_text_speed >= char_limit:
		button.disabled = false

func _physics_process(delta):
	_show_char()
	if text_trigger == false:
		panel.visible = false
		reset_labels()
	elif text_trigger == true:
		panel.visible = true
		#text_trigger = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_button_pressed():
	# Check if the current label has finished drawing its text
	if draw_text_speed >= char_limit:
	# Progress to the next label
		current_label_index += 1
	if current_label_index < 2:  # Only two labels in this case
		button.disabled = true 
		reset_labels()
	else:
	# Optionally reset or handle the end of all labels
		current_label_index = 0
		button.disabled = true
		text_trigger = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		player.lockedMovement = false
		#reset_labels()

func _on_trigger_entered(body):
	if body.name == "Player":  # Assuming the player node is named "Player"
		print_debug('Hey this is working btw!')
		text_trigger = true
		text_trigger_area.queue_free()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.lockedMovement = true
