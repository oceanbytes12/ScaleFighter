extends Node2D
const GAME_SCENE = "res://Scenes/Game.tscn"
@onready var animator := $CanvasLayer/ColorRect/AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Attack"):
		animator.play("FadeOut")
		await get_tree().create_timer(1).timeout
		get_tree().call_deferred(&"change_scene_to_packed", preload(GAME_SCENE))
		
