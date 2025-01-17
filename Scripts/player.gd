extends CharacterBody3D

var isRunning
var lockedMovement: bool = false
var moving

var footstepFilepath = "res://Assets/Sounds/Footsteps/wood/"
var footstepSounds = []


const WalkSpeed = 2
const RunSpeed = 3.5
const JumpVelocity = 4.5
const Sensitivity = 0.003

#headbob
const WalkBobAmp = .04
const RunBobAmp = .05
const WalkBobRate = 10
const RunBobRate = 17
#footsteps
var footstepProgress = 0
var prevFootstepProgress = 0

@onready var pivot = $pivot
@onready var camera = $pivot/cameraNode/camera

@onready var footstepAudioPlayer = $"Footstep Audio"

@onready var visionLight = preload("res://Scenes/vision_light.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	loadFootsteps()
	print(visionLight)
		
	
func loadFootsteps():
	var steps = DirAccess.get_files_at(footstepFilepath)
	for foot in steps:
		if foot.ends_with(".ogg"):
			var newFoot = load(footstepFilepath+"//"+foot)
			footstepSounds.append(newFoot)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and lockedMovement == false:
		pivot.rotate_y(-event.relative.x * Sensitivity)
		camera.rotate_x(-event.relative.y * Sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func GetBobOffset(t, running):
	if running:
		return Vector3(sin(t * RunBobRate/2), sin(t * RunBobRate), 0) * RunBobAmp
	else:
		return Vector3(sin(t * WalkBobRate/2), sin(t * WalkBobRate), 0) * WalkBobAmp
	
func playFootstep():
	var sound = footstepSounds.pick_random()
	footstepAudioPlayer.stream = sound
	footstepAudioPlayer.play()
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JumpVelocity
		
	var speed
	var bobAmp
	if Input.is_action_pressed("run"):
		isRunning = true
		speed = RunSpeed
		bobAmp = RunBobAmp
	else:
		isRunning = false
		speed = WalkSpeed
		bobAmp = WalkBobAmp

	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction and lockedMovement == false:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		elif lockedMovement == false:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 15.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 15.0)
	elif lockedMovement == false:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	if lockedMovement == true:
		velocity.x = 0
		velocity.z = 0
	elif velocity.length() > .1 and is_on_floor():
		moving = true
	else:
		moving = false
	
	var target = GetBobOffset(Time.get_unix_time_from_system(), isRunning) * (velocity.length() / speed) * float(is_on_floor())
	camera.transform.origin = lerp(camera.transform.origin, target, .1)
	
	## play footsteps
	if moving:
		if isRunning:
			footstepProgress = fmod(Time.get_unix_time_from_system()* RunBobRate, 2 * PI)
		else:
			footstepProgress = fmod(Time.get_unix_time_from_system()* WalkBobRate, 2 * PI)
		
		if footstepProgress < prevFootstepProgress:
			playFootstep()

		
		prevFootstepProgress = footstepProgress
		

	move_and_slide()

func _process(delta):
	pass

func _on_timer_timeout():
	pass # Replace with function body.
