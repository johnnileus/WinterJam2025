extends Node3D

var avgCooldown = 10
var soundDelay = 1.5


var curCooldown = 0
var lastActivated = 0

@onready var flash_duration = $flashDuration
@onready var sound_delay = $soundDelay
@onready var thunder_sound = $thunderSound

@export var lightPaths = []

var lightNodes = []



func _ready():
	for light in lightPaths:
		lightNodes.append(get_node(light))
		print(light)

func startLightning(light):
	light.visible = true
	flash_duration.start()
	
	sound_delay.start()
	
func _on_timer_timeout():
	lightNodes[0].visible = false
	
	
func _on_sound_delay_timeout():
	thunder_sound.play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lastActivated + curCooldown < Time.get_unix_time_from_system():
		curCooldown = avgCooldown
		startLightning(lightNodes[0])
		lastActivated = Time.get_unix_time_from_system()
