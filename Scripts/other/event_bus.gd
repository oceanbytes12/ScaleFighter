extends Node

signal on_slam_finish(amount)
signal on_player_grow
signal on_player_take_damage(amount)

signal on_game_ready
#signal on_damage_at_position(hit_position) # Not in use

signal on_enemy_critical_damage(amount)
signal on_enemy_minor_damage(amount)
signal on_boss_defeat

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"
const GLIDING = "Gliding"
const PUNCHING = "Punching"
const AIRPUNCH = "AirPunching"
const SLAM = "Slamming"
const SLAMFINISH = "SlamFinish"
const PLAYERHURT = "Hurt"
