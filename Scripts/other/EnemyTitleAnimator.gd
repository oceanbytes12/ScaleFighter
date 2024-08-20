class_name EnemyTitleAnimator extends Node2D

@export var wordAnimTime = 1.5
@export var countdownAnimTime = 0.6
#@export var announcerVoice := PackedScene
const announcer_SCENE = "res://Scenes/Other/AnnouncerVoice.tscn"

@onready var animator := $AnimationPlayer
# Plays enemy title animation
var play_automatically = false
func _ready():
	if(play_automatically):
		animator.play("CountDown")

func DisplayEnemyTitle(enemy_name):
	animator.play("CountDown")

func EndCountdown():
	LevelBase.FightStarted = true
