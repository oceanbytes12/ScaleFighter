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
@onready var animator := $Flipped/AnimationPlayer
@onready var punch_hitbox := $Flipped/PunchHitbox
@onready var slam_hitbox := $Flipped/SlamHitbox
@onready var Flipped := $Flipped
@onready var Feet := $Feet
signal on_take_damage(damageamount)

var tween
var isright

var power = 1

static var mainPlayer : Player

func _ready():
	mainPlayer = self
	pass

func _process(_delta: float) -> void:
	label.text = fsm.state.name
	if Input.is_action_just_pressed("Grow"): #and LevelBase.can_grow:
		EventBus.on_player_grow.emit()
		grow()
	
	var input_direction_x = Input.get_axis("Left", "Right")
	if input_direction_x < 0:
		Flipped.scale.x = -1
	elif(input_direction_x > 0):
		Flipped.scale.x = 1
		
func animate(animationname):
	animator.play(animationname)

func take_hit(position, damage, knockback):
	var knockback_velocity = (self.global_position-position).normalized() * knockback
	knockback_velocity.y = min(knockback_velocity.y, -200)
	velocity = knockback_velocity
	on_take_damage.emit(damage)
	fsm.state.finished.emit("Hurt")
	EventBus.on_player_take_damage.emit(damage)

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
	
	power = scale.x*10
