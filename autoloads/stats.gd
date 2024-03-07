extends Node

const MOVEMENT_SPEED = 8000.0
const BULLET_SPEED = 500.0
const HEALTH_DECREASE = 2.0
const HURT_HEALTH_DECREASE = 15.0
const ENEMY_KILL_HEALTH_INCREASE = 10.0
const BULLET_BOUNCE = 1

var movement_speed: float
var bullet_speed: float
var health_decrease: float
var hurt_health_decrease: float
var enemy_kill_health_increase: float
var bullet_bounce: int

func _ready() -> void:
	reset_stats()

func reset_stats():
	movement_speed = MOVEMENT_SPEED
	bullet_speed = BULLET_SPEED
	health_decrease = HEALTH_DECREASE
	hurt_health_decrease = HURT_HEALTH_DECREASE
	enemy_kill_health_increase = ENEMY_KILL_HEALTH_INCREASE
	bullet_bounce = BULLET_BOUNCE
