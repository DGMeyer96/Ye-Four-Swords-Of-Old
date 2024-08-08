extends CharacterBody2D

const SPEED = 300.0
const attackSpeed = 0.5
const attackComboTime = 0.9

var attackCombo = 0
var timeSinceLastAttack = attackSpeed

@onready var _sprite2D = $Sprite2D
@onready var _animation_tree = $AnimationTree

func _physics_process(delta):
	#region Movement
	# Get the input direction and handle the movement/deceleration.
	
	# Process horizontal input
	var directionX = Input.get_axis("left", "right")
	if directionX:
		velocity.x += directionX * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Process vertical input
	var directionY = Input.get_axis("up", "down")
	if directionY:
		velocity.y += directionY * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	# Normalize to prevent faster movement when going diagonal
	velocity = velocity.normalized() * SPEED
	#endregion
		
	#region Animations
	# Don't flip sprite if no input
	if directionX < 0:
		_sprite2D.flip_h = true
	elif directionX > 0:
		_sprite2D.flip_h = false
	
	## Handle Idle/Movement animations
	_animation_tree.set("parameters/conditions/isIdle", velocity.length() < 0.01)
	_animation_tree.set("parameters/conditions/isMoving", velocity.length() > 0.01)
	
	## Handle attack animations
	if timeSinceLastAttack > attackSpeed:
		var isAttacking = Input.is_action_just_pressed("attack")
		# Attack 1 is triggered is trying to attack and start of combo
		if isAttacking && attackCombo == 0:
			_animation_tree.set("parameters/conditions/isAttacking", true)
			attackCombo = 1
			timeSinceLastAttack = 0.0
		# We are trying to attack again right after first attack
		elif isAttacking && attackCombo == 1 && timeSinceLastAttack < attackComboTime:
			_animation_tree.set("parameters/conditions/isAttacking2", true)
			timeSinceLastAttack = 0.0
			attackCombo = 2
		# Full combo chain reached, reset
		elif timeSinceLastAttack > attackComboTime || attackCombo > 1:
			attackCombo = 0
			_animation_tree.set("parameters/conditions/isAttacking", false)
			_animation_tree.set("parameters/conditions/isAttacking2", false)
	# Too early to attack again, reset
	else:
		_animation_tree.set("parameters/conditions/isAttacking", false)
		_animation_tree.set("parameters/conditions/isAttacking2", false)
	
	# Increment attack
	timeSinceLastAttack += delta
	#endregion

	move_and_slide()
