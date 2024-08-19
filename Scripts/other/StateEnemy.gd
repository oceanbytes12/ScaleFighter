# Character that moves and jumps.
class_name StateEnemy extends CharacterBody2D

@export var gravity := 4000.0
@export var SPEED = 30
@export var GRAVITY = 3
@onready var fsm := $StateMachine
@onready var Flipped := $Flipped
@onready var label := $Label
@onready var animator := $Flipped/AnimationPlayer
@onready var hit_animator := $Flipped/HitAnimationPlayer
@export var hurtbox : HurtBox
@export var bodyhitbox : CollisionShape2D

var TARGET : Player
var power = 1
var max_armor = 40
var current_armor
var is_on_wall = false

func _ready():
	current_armor = max_armor
	TARGET = Player.mainPlayer
	hurtbox.take_damage.connect(hit)
	print("Connecting!")
	
func SetEnemyBodyDamages(isOn):
	print("Turning body damage: ", isOn)
	#bodyhitbox.disabled = !isOn
	bodyhitbox.set_deferred("disabled", !isOn)

func _process(_delta: float) -> void:
	label.text = fsm.state.name
		
func animate(animationname):
	animator.play(animationname)

func Flip(isFlipped):
	if isFlipped:
		Flipped.scale.x = -1
	else:
		Flipped.scale.x = 1

func hit(hit_position, damage, knockback):
	print("hit")
	hit_animator.play("hit")
	EventBus.on_enemy_take_damage.emit(damage)
	current_armor-=damage
	if(current_armor <= 0):
		current_armor = max_armor
		var knockback_velocity = (self.global_position-hit_position).normalized() * knockback
		knockback_velocity.y = min(knockback_velocity.y, -400)
		velocity = knockback_velocity
		fsm.state.finished.emit("EnemyHurt")

func hit_wall(body):
	is_on_wall = true

func exit_wall(body):
	is_on_wall = false
