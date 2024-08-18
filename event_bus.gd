extends Node

signal on_slam_finish(amount)
signal on_player_grow
signal on_player_take_damage(amount)
signal on_enemy_take_damage(amount)

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
