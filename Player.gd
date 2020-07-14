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


onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var ground_ray_l = $GroundRayLeft
onready var ground_ray_r = $GroundRayRight

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		animation_player.play("Run")
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0
	else:
		animation_player.play("Idle")
		
	
	motion.y += GRAVITY * delta * TARGET_FPS
	

	if ground_ray_l.is_colliding() or ground_ray_r.is_colliding():
	#if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)
		
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		if motion.y < 0:
			animation_player.play("Jump")
		else:
			animation_player.play("Fall")
		
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
			
	motion = move_and_slide(motion, Vector2(0, -1))
