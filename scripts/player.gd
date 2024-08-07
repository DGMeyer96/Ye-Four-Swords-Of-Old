extends CharacterBody2D


const SPEED = 300.0

var attackFinished = true

@onready var _animated_sprite = $AnimatedSprite2D


func _physics_process(delta):
	#region Movement
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX = Input.get_axis("left", "right")
	if directionX:
		velocity.x += directionX * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var directionY = Input.get_axis("up", "down")
	if directionY:
		velocity.y += directionY * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	# Normalize to prevent faster movement when going diagonal
	velocity = velocity.normalized() * SPEED
		
	var attacking = Input.is_action_just_pressed("attack")
	#endregion
		
	#region Animations
	# Don't flip sprite if no input
	if directionX < 0:
		_animated_sprite.flip_h = true
	elif directionX > 0:
		_animated_sprite.flip_h = false
	
	# Handle attack animation
	if attacking:
		_animated_sprite.play("attack_right_1")
		attackFinished = false
	
	# Only play idle/movement anim if not attacking
	if attackFinished:
		# Vector2.length() is magnitude
		if velocity.length() < 0.01:
			_animated_sprite.play("idle")
		else:
			_animated_sprite.play("move_right")
	#endregion

	move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	attackFinished = true
