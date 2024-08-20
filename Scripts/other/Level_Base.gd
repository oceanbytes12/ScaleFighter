class_name LevelBase extends Node2D
@export var is_last_level = false
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
@export var PlayerBar : GameBar

static var PlayerDefeated = false
static var BossDefeated = false
static var FightStarted = false
static var can_grow = false

func _ready():
	FightStarted = false
	PlayerDefeated = false
	BossDefeated = false
	can_grow = false
	
	#The player informs the game about this damage
	EventBus.on_player_take_damage.connect(HandlePlayerDamage)
	#Handle lethal and nonlethal damage
	EventBus.on_enemy_minor_damage.connect(HandleEnemyMinorDamage)
	#Handle armor breaking
	EventBus.on_enemy_critical_damage.connect(HandleEnemyCriticalDamage)
	#Turn off UI when we are big.
	EventBus.on_player_grow.connect(TurnOffUI)
	#Shake the screen and stuff when slams happen.
	EventBus.on_slam_finish.connect(HandleSlam)
	
	if(animator):
		print("Playing FadeIn")
		animator.play("FadeIn")
		
	await get_tree().create_timer(1).timeout
	
	ShowTitleAnim()

func HandleSlam(slamamount):
	HitStop(0.5, 0.1)
	
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
			

func HitStop(duration, scale):
	Engine.time_scale = scale
	await get_tree().create_timer(duration*scale).timeout
	Engine.time_scale = 1
	
func _on_grow_bar_full():
	# Text prompt on screen for player: "Press 'G' to Grow!"
	grow_text.visible = true
	can_grow = true

func _on_boss_hp_bar_empty():
	# Level Complete
	if is_last_level:
		win_text.visible = true
		await get_tree().create_timer(3).timeout
		if(animator):
			animator.play("FadeOut")
			await get_tree().create_timer(1).timeout
			get_tree().call_deferred(&"change_scene_to_file", title_scene)
	else:
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

func HandlePlayerDamage(damageamount):
	#Inform UI
	PlayerBar._on_damage_received(damageamount)
	
	#Handle Game Over
	if(PlayerBar.value <= 0):
		#Inform the game we lost.
		PlayerDefeated = true
		
		#HitStop
		Engine.time_scale = 0.05
		await get_tree().create_timer(1.2*0.05).timeout
		Engine.time_scale = 1
		
		#Show them the game over text for 3 seconds.
		gameover_text.visible = true
		await get_tree().create_timer(3).timeout
		
		#Fadeout
		if(animator):
			animator.play("FadeOut")
		
		#Fade technically happens in current scene.
		await get_tree().create_timer(1).timeout
		get_tree().call_deferred("reload_current_scene")
		
	elif(damageamount > 10):
		HitStop(0.4, 0.1)

func HandleEnemyMinorDamage(amount):
	if(BossDefeated):
		return
		
	BossBar._on_damage_received(amount)
	if(0 >= BossBar.value):
		print("BOSS DEFEATED")
		BossDefeated = true
		HitStop(1.2, 0.05)
		
	elif(amount > 10):
		HitStop(0.4, 0.1)
	
	GrowBar._on_damage_received(amount)

func HandleEnemyCriticalDamage(amount):
	if(BossDefeated):
		return
		
	BossBar._on_damage_received(amount)
	if(0 >= BossBar.value):
		print("BOSS DEFEATED")
		BossDefeated = true
		HitStop(1.2, 0.05)
	else:
		GrowBar._on_damage_received(amount)
		HitStop(0.6, 0.05)
	
