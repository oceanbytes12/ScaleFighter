extends CharacterBody2D

class_name Boss

signal DamageTaken

@export var SPEED = 100.0
@export var TARGET := CharacterBody2D
@export var MIN_DISTANCE = .8

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 10000

@onready var cooldown_timer = $CooldownTimer

var isPlayerInRange = false # Is player in range for attack? 
var isCoolingDown = false #Are we still cooling down?
var isAttacking = false # Are we currently playing an attack animation?

func _ready():
	if TARGET == null:
		push_error("ERROR: Enemy does not have a valid TARGET set")
	

func _process(delta):
	var target_vector = TARGET.global_position - global_position
	if target_vector.x < 0:
		$Art/Sprite2D.flip_h = true
	elif target_vector.x > 0:
		$Art/Sprite2D.flip_h = false


func _physics_process(delta):
	if isAttacking:
		# Don't move if currently attacking
		velocity = Vector2.ZERO
		
	elif isPlayerInRange && !isCoolingDown:
		DoAttack()
		
	else: 
		# Move towards target
		var direction = TARGET.position - position
		direction = direction.normalized()
		direction.y = 0 # Stop following the player on the y axis
		
		if (abs(direction.x) > MIN_DISTANCE):
			velocity = direction * SPEED
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()


func DoAttack():
	# Randomly choose an attack
	#var gen = RandomNumberGenerator.new()
	#var random_num = gen.rand_range(1, 3)
	#
	#match random_num:
		#1:
			#Attack1()
		#2:
			#Attack2()
		#3:
			#Attack3()

	# For now, just has one attack
	Attack1() 


func Attack1():
	print("Attack1 called")
	DoAttackAnimation()
	
func Attack2():
	pass
	
func Attack3():
	pass


func DoAttackAnimation():
	isAttacking = true
	cooldown_timer.start()
	isCoolingDown = true
	
	# Temporary:
	isAttacking = false # LATER: Have a signal at the end of the animation that sets this back to false


func _on_attack_range_body_entered(body):
	if body == TARGET:
		print("player in attackable range")
		isPlayerInRange = true


func _on_attack_range_body_exited(body):
	if body == TARGET:
		print("player out of attackable range")
		isPlayerInRange = false


func _on_cooldown_timer_timeout():
	print("Can attack again")
	isCoolingDown = false


func _on_attack_effect_animation_finished():
	print("Animation finished")
	$AttackEffects/AttackEffect.visible = false
	isAttacking = false


func DamageReceived(amount):
	DamageTaken.emit(amount) # Hook this up to an HP Bar
