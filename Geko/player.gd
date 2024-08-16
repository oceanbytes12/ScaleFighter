extends CharacterBody2D

@onready var land_effect = preload("res://Geko/land_effect.tscn")
@onready var jump_effect = preload("res://Geko/JumpEffect.tscn")

@export var movement_speed = 200.0
@export var jump_power = -400.0
@export var coyote_time = 0.2
@export var jump_time = 0.1
@export var glide_gravity = 160.0
@export var glide_boost = 20.0
@export var glide_time = 4

const default_gravity = 980.0

var gravity = default_gravity
var x_boost = 0
var state = "idle"
var saved_jump = false
var coyote_save = "ground"
var can_glide = false
var facing = 1

func _physics_process(delta):
	var above_something = false
	#print("Physics")
	for body in $Area2D.get_overlapping_bodies():
		print("Grounded")
		if body.name == "Ground":
			print("Grounded2")
			above_something = true
	
	if is_on_floor():
		coyote_save = "ground"
	elif coyote_save == "ground":
		coyote_time_handler()

	if Input.is_action_just_pressed("ui_accept"):
		saved_jump_time_handler()
	if Input.is_action_just_pressed("Grow"):
		grow()
	# Handle jumping and gliding
	# Is on the ground or in coyote time
	if saved_jump and (is_on_floor() or coyote_save =="open"):
		velocity.y = jump_power
		saved_jump = false
		coyote_save = "closed"
	# In the air 
	elif saved_jump and can_glide and not above_something:
		velocity.y = 0
		gravity = glide_gravity
		x_boost = glide_boost
		can_glide = false
		saved_jump = false
	# Reseting gravity and boost regarless if gliding
	elif saved_jump and not is_on_floor():
		gravity = default_gravity
		x_boost = 0

	if is_on_floor():
		can_glide = true
		x_boost = 0
		gravity = default_gravity
	else:
		velocity.y += gravity * delta

	# Left/Right movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		facing = direction
	if direction:
		velocity.x = direction * movement_speed + x_boost*facing
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.2)+ x_boost*facing
		
	move_and_slide()
	
	# Set image facing
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	
	# Set state
	if direction == 0 and is_on_floor():
		state = handle_state_change(state, "idle")
	elif is_on_floor():
		state = handle_state_change(state, "walking")
	elif not is_on_floor() and gravity < default_gravity:
		state = handle_state_change(state, "gliding")
	elif not is_on_floor() and velocity.y < 0:
		state = handle_state_change(state, "jumping")
	elif not is_on_floor():
		state = handle_state_change(state, "falling")
var tween
func grow():
	if(tween and tween.is_running()):
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	var start_scale = scale
	var target_scale = Vector2(scale.x+0.5, scale.y+0.5)  # Scale to twice the original size
	tween.tween_property(self, "scale", target_scale, 1).from(start_scale)  # Easing out for a smooth finish

func handle_state_change(old_state, new_state):
	var was_grounded = (old_state == "idle" or old_state == "walking")
	var is_grounded = (new_state == "idle" or new_state == "walking")
	var was_in_air = (old_state == "falling" or old_state=="gliding")
	if was_grounded and new_state == "jumping":
		$AnimatedSprite2D.play("Jump")
		play_effect(jump_effect)
	if is_grounded and was_in_air:
		play_effect(land_effect)
	if new_state == "falling":
		$AnimatedSprite2D.play("Fall")
	if new_state == "idle":
		$AnimatedSprite2D.play("Idle")
	if new_state == "walking":
		$AnimatedSprite2D.play("Walking")
	if new_state == "gliding":
		$AnimatedSprite2D.play("Glide")
	return new_state

func play_effect(effect):
	var dust = effect.instantiate()
	get_parent().get_parent().add_child(dust)
	dust.global_position = global_position
	dust.flip_h = !$AnimatedSprite2D.flip_h
	
func coyote_time_handler():
	coyote_save = "open"
	await get_tree().create_timer(coyote_time).timeout
	coyote_save = "closed"

func saved_jump_time_handler():
	saved_jump = true
	await get_tree().create_timer(jump_time).timeout
	saved_jump = false
