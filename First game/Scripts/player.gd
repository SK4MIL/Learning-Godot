extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var player_death = $PlayerDeath

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#Disable inputs when dying
	if player_death.is_playing():
		velocity.x = 0
		move_and_slide()
		return
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	#Define direction
	var direction = Input.get_axis("move_left", "move_right")
	
	#Sprite rotation
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	#Animations
	if is_on_floor():
		if direction != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("Idle")
	else:
		animated_sprite.play("jump")
		
	#Move
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
