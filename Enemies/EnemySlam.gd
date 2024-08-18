extends CharacterBody2D

#warning: This code may still be a little buggy

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
var isSlamming = false

# Not needed?
#var slamTargetLocation = null

func _ready():
	pass

func _physics_process(delta):
	
	if isJumping && is_on_floor():
		isSlamming = false
		isJumping = false
	if isSlamming && is_on_floor():
		isSlamming = false
		isJumping = false
		

	if isCoolingDown && is_on_floor():
		# Stop movement on ground towards player
		velocity.x = 0


	# Jump towards target
	if !isCoolingDown and is_on_floor():
		# Get direction of target
		var direction = TARGET.position - position
		# This can overshoot the player. We want it to aim for and land on player:
		direction = direction.normalized() * SPEED 

		velocity.y = JUMP_VELOCITY
		velocity.x = direction.x
		#velocity.x = move_toward(direction.x, 0, SPEED)
		#cooldown_timer.start()
		#isCoolingDown = true
		isJumping = true
		#print("starting jump")

	if isJumping:
		#print("is jumping")
		# Check if we are on top of the player. Stop moving in x dir if yes
		#var roundedXDistance = round_to_two_places(TARGET.global_position.x - global_position.x)
		#print(roundedXDistance) 
		# Current issue is that this value jumps from -1 to 3 with no zero in between
		if (int)(TARGET.global_position.x - global_position.x) == 0:
			velocity.x = 0
			#print("over target")
		
		if velocity.y > 0:
			#print("starting slam")
			velocity.x = 0
			# Initiate slam towards player
			# Take snapshot of player's location at start of slam
			#slamTargetLocation = TARGET.global_position
			isSlamming = true
			isJumping = false
			cooldown_timer.start()
			isCoolingDown = true

	if isSlamming:
		#print("Slamming")
		# Get direction of slam target
		#var direction = slamTargetLocation.global_position - global_position
		velocity.y = velocity.y + 1000 * delta

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	move_and_slide()


func _on_cooldown_timer_timeout():
	isCoolingDown = false

# May not be needed
func round_to_two_places(value: float) -> float:
	return round(value * 100) / 100.0
