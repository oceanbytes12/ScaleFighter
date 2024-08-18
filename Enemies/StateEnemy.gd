# Character that moves and jumps.
class_name StateEnemy extends CharacterBody2D

@export var gravity := 4000.0
@export var SPEED = 30
@export var GRAVITY = 3
@export var TARGET : Player
@onready var fsm := $StateMachine
@onready var Flipped := $Flipped
@onready var label := $Label
@onready var animator := $Flipped/AnimationPlayer
@onready var hit_animator := $Flipped/HitAnimationPlayer
var power = 1
var armor = 30

signal take_damage(damageamount)

func _ready():
	TARGET = Player.mainPlayer

func _process(_delta: float) -> void:
	label.text = fsm.state.name
		
		
func animate(animationname):
	animator.play(animationname)

func take_hit(hit_position, damage, knockback):
	print("FLASHING")
	hit_animator.play("hit")
	EventBus.on_enemy_take_damage.emit(damage)
	armor-=damage
	if(armor <= 0):
		armor = 30
		var knockback_velocity = (self.global_position-hit_position).normalized() * knockback
		knockback_velocity.y = min(knockback_velocity.y, -400)
		velocity = knockback_velocity
		fsm.state.finished.emit("EnemyHurt")

	take_damage.emit(damage)
