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
var grow_amount = 1
var grow_time = 0.5
@onready var fsm := $StateMachine
@onready var label := $Label
@onready var animator := $AnimationPlayer
@onready var punch_hitbox := $PunchHitbox
@onready var slam_hitbox := $SlamHitbox

signal on_take_damage(damageamount)

var tween

func _ready():
	punch_hitbox.our_body = self
	slam_hitbox.our_body = self
	pass

func _process(_delta: float) -> void:
	label.text = fsm.state.name
	if Input.is_action_just_pressed("Grow"): #and LevelBase.can_grow:
		EventBus.on_player_grow.emit()
		grow()

func animate(animationname):
	animator.play(animationname)

func take_hit(global_position, damage):
	on_take_damage.emit(damage)

func grow():
	if(tween and tween.is_running()):
		tween.kill()
		
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	var start_scale = scale
	var target_scale = Vector2(scale.x+grow_amount, scale.y+grow_amount)  # Scale to twice the original size
	var second_scale = Vector2(scale.x+grow_amount*2, scale.y+grow_amount*2)
	var third_scale = Vector2(scale.x+grow_amount*3, scale.y+grow_amount*3)
	tween.tween_property(self, "scale", target_scale, grow_time).from(start_scale)  # Easing out for a smooth finish
	tween.chain().tween_property(self, "scale", second_scale, grow_time).from(target_scale)
	tween.chain().tween_property(self, "scale", third_scale, grow_time).from(second_scale)
	
	await tween.finished
	
	LevelBase.character_scale = scale.x
