class_name LevelBase extends Node2D
@export var grow_text : RichTextLabel
@export var gameover_text : RichTextLabel
@export var win_text : RichTextLabel
@export var right_wall_collider : CollisionShape2D
@export_enum("None", "Jump", "Slam") var power_unlocked
@export var next_scene = "res://Scenes/SquirrelFight.tscn"


@onready var animator := $CanvasLayer/ColorRect/AnimationPlayer

@export var GrowBar : GameBar
@export var BossBar : GameBar

static var can_grow = false


func _ready():
	print(next_scene)
	EventBus.on_player_grow.connect(TurnOffUI)
	EventBus.on_player_take_damage.connect(HandleTakeDamage)
	EventBus.on_enemy_take_damage.connect(HandleTakeDamage)
	if(animator):
		animator.play("FadeIn")
	await get_tree().create_timer(1).timeout
	EventBus.on_game_ready.emit()


func TurnOffUI():
	grow_text.visible = false

func HandleTakeDamage(amount):
	GrowBar._on_damage_received(amount)
	BossBar._on_damage_received(amount)
	if(amount > 10):
		var duration = 0.4
		var timeScale = 0.1
		Engine.time_scale = timeScale
		await get_tree().create_timer(duration*timeScale).timeout
		Engine.time_scale = 1
	
	
	
func _on_player_hp_bar_empty():
	# Game Over text appears on screen
	gameover_text.visible = true
	get_tree().paused = true


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
		#Show temp text so we know it's not frozen?
		print("Player exited level.")
		#get_tree().paused = true
		load_scene()


func load_scene():
	can_grow = false
	#get_tree().call_deferred("reload_current_scene")
	#get_tree().call_deferred(&"change_scene_to_packed", preload(GAME_SCENE))
	#get_tree().change_scene_to_file(next_scene)
	get_tree().call_deferred(&"change_scene_to_file", next_scene)
