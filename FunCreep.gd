extends KinematicBody2D
#Engine.iterations_per_second
const TARGET_FPS = Engine.iterations_per_second # Needed?
const ACCELERATION = 10 # Needed?
const MAX_SPEED = 80
const FRICTION = 12 # Needed?
const AIR_RESISTANCE = 2
const GRAVITY = 4
const JUMP_FORCE = 145

const SPEED = 30


var motion = Vector2.ZERO

var direction = -1

onready var player = get_parent().get_node("Player")
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var ground_ray_l = $GroundRayLeft
onready var ground_ray_r = $GroundRayRight
onready var body_ray_l = $BodyRayLeft
onready var body_ray_r = $BodyRayRight

func _ready():
	pass
	

func _physics_process(delta):
	motion.x = SPEED * direction
	
	print(sprite.flip_h)
		
	if motion.x < 0:
		animation_player.play("Run")
		sprite.flip_h = false
	elif motion.x > 0:
		animation_player.play("Run")
		sprite.flip_h = true
	else:
		animation_player.play("Idle")
		
	
	motion.y += GRAVITY * delta * TARGET_FPS
	
	if body_ray_l.is_colliding():
		direction = 1
	if body_ray_r.is_colliding():
		direction = -1

			
	motion = move_and_slide(motion, Vector2(0, -1))
