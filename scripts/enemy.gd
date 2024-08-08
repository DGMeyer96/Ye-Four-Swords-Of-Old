extends CharacterBody2D

enum enemy_type { BARREL, TNT, TORCH }

const SPEED = 300.0
const ATTACK_SPEED = 1.0

@export var type = enemy_type.BARREL
@onready var _sprite2D = $Sprite2D
@onready var _animation_tree = $AnimationTree
@onready var _shapeCast = $ShapeCast2D

func _ready():
	print("%s has TYPE: %s" % [name, type])
	_shapeCast = $ShapeCast2D

func _physics_process(delta):
	
	## Handle Idle/Movement animations
	_animation_tree.set("parameters/conditions/isIdle", velocity.length() < 0.01)
	_animation_tree.set("parameters/conditions/isMoving", velocity.length() > 0.01)
	
	if type == enemy_type.BARREL:
		_barrel_movement()
	elif type == enemy_type.TNT:
		_tnt_movement()
	elif type == enemy_type.TORCH:
		_torch_movement()
		
	# Do we see the player?
	if _shapeCast.is_colliding():
		GodotLogger.info("Detected Player")

	move_and_slide()

func _barrel_movement():
	if _shapeCast.is_colliding():
		pass
		#_animated_sprite.play("alert_to_idle")
		#for collision in _shapeCast.collision_result:
			#print("Collided with %s" % collision.collider.name)
	
func _tnt_movement():
	pass
	
func _torch_movement():
	pass
