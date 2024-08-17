# Character that moves and jumps.
class_name Player extends CharacterBody2D

@export var slam_speed := 100
@export var max_slam_speed := 300
@export var speed := 500.0
@export var gravity := 4000.0
@export var jump_impulse := 1800.0
@export var glide_max_speed := 1000.0
@export var glide_acceleration := 1000.0
@export var glide_gravity := 400.0
@export var glide_jump_impulse := 800.0
@onready var fsm := $StateMachine
@onready var label := $Label
@onready var animator := $AnimationPlayer
@onready var punch_hitbox := $PunchHitbox
@onready var slam_hitbox := $SlamHitbox

signal on_take_damage(damageamount)

func _ready():
	punch_hitbox.our_body = self
	pass

func _process(_delta: float) -> void:
	label.text = fsm.state.name
	if Input.is_action_just_pressed("Grow"):
		EventBus.on_player_grow.emit()

func animate(animationname):
	animator.play(animationname)

func take_hit(global_position, damage):
	on_take_damage.emit(damage)

