extends CharacterBody2D

@export var TARGET : Player
@export var SPEED = 100.0
@export var MIN_DISTANCE = .8

const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 1000

@onready var cooldown_timer = $CooldownTimer

var isCoolingDown = false 
var isJumping = true # In case we are in the air on level start


func _physics_process(delta):
	
	if is_on_floor():
		isJumping = false
	
	if isCoolingDown && is_on_floor():
		# Stop movement on ground towards player
		velocity.x = 0

	# Jump towards target
	if !isCoolingDown and is_on_floor():
		# Get direction of target
		var direction = TARGET.global_position - global_position
		direction = direction.normalized() * SPEED 

		velocity.y = JUMP_VELOCITY
		velocity.x = direction.x

		cooldown_timer.start()
		isCoolingDown = true
		isJumping = true

	if isJumping:
		# Check if we are on top of the player. Stop moving in x dir if yes
		if (int)(TARGET.global_position.x - global_position.x) == 0:
			velocity.x = 0
			
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	move_and_slide()


func _on_cooldown_timer_timeout():
	isCoolingDown = false
