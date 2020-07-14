extends KinematicBody2D
#Engine.iterations_per_second
const TARGET_FPS = Engine.iterations_per_second
const ACCELERATION = 10
const MAX_SPEED = 80
const FRICTION = 12
const AIR_RESISTANCE = 2
const GRAVITY = 4
const JUMP_FORCE = 145


var motion = Vector2.ZERO

var react_time = 400
var dir = 0
var next_dir = 0
var next_dir_time = 0
var target_player_dist = 60

onready var player = get_parent().get_node("Player")
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var ground_ray_l = $GroundRayLeft
onready var ground_ray_r = $GroundRayRight

func _ready():
	set_process(true)
	
func set_dir(target_dir):
	if next_dir != target_dir:
		next_dir = target_dir
		next_dir_time = OS.get_ticks_msec() + react_time

func _physics_process(delta):
	var x_input = 0
	if player.position.x < position.x - target_player_dist:
		x_input = -1
		set_dir(-1)
	elif player.position.x > position.x + target_player_dist:
		x_input = 1
		set_dir(1)
	else:
		x_input = 0
		set_dir(0)
		
	if OS.get_ticks_msec() > next_dir_time:
		dir = next_dir
		
#	motion.x = dir * 500
	
	if x_input != 0:
		animation_player.play("Run")
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input > 0
	else:
		animation_player.play("Idle")
		
	
	motion.y += GRAVITY * delta * TARGET_FPS
	

	if ground_ray_l.is_colliding() or ground_ray_r.is_colliding():
	#if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)
		
#		if Input.is_action_just_pressed("ui_up"):
#			motion.y = -JUMP_FORCE
	else:
		if motion.y < 0:
			animation_player.play("Jump")
		else:
			animation_player.play("Fall")
		
#		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
#			motion.y = -JUMP_FORCE/2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
			
	motion = move_and_slide(motion, Vector2(0, -1))
