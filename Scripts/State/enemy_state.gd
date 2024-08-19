# Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name EnemyState extends State

const IDLE = "EnemyIdle"
const CHASE = "EnemyChase"
const PUNCH = "EnemyPunch"
const JUMP = "EnemyJump"
const FALL = "EnemyFall"
var player: StateEnemy

func _ready() -> void:
	await owner.ready
	player = owner as StateEnemy
	assert(player != null)
