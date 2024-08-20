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
@export var particle_gen : PackedScene

var TARGET : Player
var power = 1
var max_armor = 40
var current_armor
var is_on_wall = false
var isPlayerLarge = false # Used to track how large the hit_effects should be

func _ready():
	current_armor = max_armor
	TARGET = Player.mainPlayer
	hurtbox.take_damage.connect(hit)
	print("Connecting!")
	EventBus.on_player_grow.connect(PlayerGrew)

func PlayerGrew():
	isPlayerLarge = true;
#Blink on damage
func Blink():
	hit_animator.play("hit")
#Inform if the enemies body should hurt the player.
func SetEnemyBodyDamages(isOn):
	bodyhitbox.set_deferred("disabled", !isOn)
#Inform if the enemies body should be damageable.
func ToggleHurtBox(isOn):
	hurtbox.toggle(isOn)
#Debug
func _process(_delta: float) -> void:
	label.text = fsm.state.name
#Show the right state to the player.
func animate(animationname):
	animator.play(animationname)
#Flip visual and important collision.
func Flip(isFlipped):
	if isFlipped:
		Flipped.scale.x = -1
	else:
		Flipped.scale.x = 1
#Show damage via effects
func generate_effect():
	# Generate hit effect 
	var particleNode = particle_gen.instantiate()
	particleNode.global_position = global_position
	if isPlayerLarge:
		# hit_effects from players should be doubled in size
		particleNode.scale = particleNode.scale*2
	get_parent().add_child(particleNode)
#Handling incoming damage.
func hit(hit_position, damage, knockback):
	#Flash White
	Blink()
	#Show punch particles
	generate_effect()
	#Reduce Armor
	current_armor-=damage
	#Inform of the hit.
	if(current_armor <= 0):
		EventBus.on_enemy_critical_damage.emit(damage)
	else:
		EventBus.on_enemy_minor_damage.emit(damage)
		
	#If us being hit caused us to die.
	if(LevelBase.BossDefeated == true):
		var knockback_velocity = (self.global_position-hit_position).normalized() * 1200
		knockback_velocity.y = min(knockback_velocity.y, -800)
		velocity = knockback_velocity
		fsm.state.finished.emit("EnemyDefeated")
	#If us being hit caused us to lose all our armor.
	elif(current_armor <= 0):
		current_armor = max_armor+10
		var knockback_velocity = (self.global_position-hit_position).normalized() * 600
		knockback_velocity.y = min(knockback_velocity.y, -400)
		velocity = knockback_velocity
		fsm.state.finished.emit("EnemyHurt")
#Sensing how close we are to a wall.
func hit_wall(_body):
	is_on_wall = true
func exit_wall(_body):
	is_on_wall = false
