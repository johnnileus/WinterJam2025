extends SpotLight3D

var startEnergy
var startTime
@export var decayTime = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	startEnergy = light_energy
	startTime = Time.get_unix_time_from_system()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ratio = (Time.get_unix_time_from_system() - startTime) / decayTime
	
	light_energy = lerp(startEnergy, 0.0, ratio)
	if ratio > 1:
		queue_free()
