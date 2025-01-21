extends Label

var drawTextSpeed: int = 0

var textTrigger: bool = false

var charLimit: int = 100 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _showChar():
	if drawTextSpeed < charLimit && textTrigger:
		drawTextSpeed += 1
		self.visible_characters = drawTextSpeed
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_showChar()
	pass
