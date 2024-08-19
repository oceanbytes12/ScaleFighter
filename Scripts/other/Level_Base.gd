class_name LevelBase extends Node2D
@export var grow_text : RichTextLabel
@export var gameover_text : RichTextLabel
@export var win_text : RichTextLabel
@export var right_wall_collider : CollisionShape2D
@export_enum("None", "Jump", "Slam") var power_unlocked
@export_enum("Squirrel", "Kong", "Godzilla") var title_toshow
@export var next_scene = "res://Scenes/SquirrelFight.tscn"
const title_scene = "res://Scenes/Title.tscn"

@onready var animator := $CanvasLayer/ColorRect/AnimationPlayer
@onready var title_animator := $TitleAnimator
@export var GrowBar : GameBar
@export var BossBar : GameBar

static var BossDefeated = false
static var can_grow = false

func _ready():
	BossDefeated = false
	can_grow = false
	
	EventBus.on_player_grow.connect(TurnOffUI)
	EventBus.on_player_take_damage.connect(HandlePlayerTakeDamage)
	#Handle lethal and nonlethal damage
	EventBus.on_enemy_minor_damage.connect(HandleEnemyMinorDamage)
	#Handle armor breaking
	EventBus.on_enemy_critical_damage.connect(HandleEnemyCriticalDamage)
	
	if(animator):
		print("Playing FadeIn")
		animator.play("FadeIn")
	await get_tree().create_timer(1).timeout
	
	ShowTitleAnim()
	
	EventBus.on_game_ready.emit()

func TurnOffUI():
	grow_text.visible = false
	
func ShowTitleAnim():
	# Need to pass strings to title_animator
	match title_toshow:
		0: 
			title_animator.DisplayEnemyTitle("Squirrel")
		1:
			title_animator.DisplayEnemyTitle("Kong")
		2:
			title_animator.DisplayEnemyTitle("Godzilla")
	get_tree().paused = true
	await get_tree().create_timer(6.5).timeout # Change this value to match with title_animator
	get_tree().paused = false

func HandlePlayerTakeDamage(amount):
	if(amount > 10):
		HitStop(0.4, 0.1)

func HandleEnemyCriticalDamage(amount):
	if(BossDefeated):
		return
		
	BossBar._on_damage_received(amount)
	if(0 >= BossBar.value):
		print("BOSS DEFEATED")
		BossDefeated = true
		EventBus.on_boss_defeat.emit()
		HitStop(1.2, 0.05)
	else:
		GrowBar._on_damage_received(amount)
		HitStop(1, 0.1)
	
func HandleEnemyMinorDamage(amount):
	if(BossDefeated):
		return
		
	BossBar._on_damage_received(amount)
	if(0 >= BossBar.value):
		print("BOSS DEFEATED")
		BossDefeated = true
		HitStop(1.2, 0.05)
		EventBus.on_boss_defeat.emit()
		
	elif(amount > 10):
		HitStop(0.4, 0.1)
	
	GrowBar._on_damage_received(amount)

func HitStop(duration, scale):
	Engine.time_scale = scale
	await get_tree().create_timer(duration*scale).timeout
	Engine.time_scale = 1
	
func _on_player_hp_bar_empty():
	# Game Over text appears on screen
	#gameover_text.visible = true
	#get_tree().paused = true
	if(animator):
		animator.play("FadeOut")
	await get_tree().create_timer(1).timeout
	get_tree().call_deferred(&"change_scene_to_file", title_scene)


func _on_grow_bar_full():
	# Text prompt on screen for player: "Press 'G' to Grow!"	
	grow_text.visible = true
	can_grow = true

func _on_boss_hp_bar_empty():
	# Level Complete
	# Disable right wall
	right_wall_collider.set_deferred("disabled", true)
	# Display new power text	
	win_text.visible = true
	
	# Unlock player power
	match power_unlocked:
		1:
			Player.canJump = true
		2:
			Player.canSlam = true

func _on_exit_level_trigger_body_entered(body):  
	if body is Player:
		# Load next level
		can_grow = false
		if(animator):
			print("has animator")
			animator.play("FadeOut")
		await get_tree().create_timer(1).timeout
		get_tree().call_deferred(&"change_scene_to_file", next_scene)
