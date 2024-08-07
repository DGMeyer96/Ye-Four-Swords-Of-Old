extends CharacterBody2D

enum enemy_type { BARREL, TNT, TORCH }

const SPEED = 300.0

@export var type = enemy_type.BARREL
@onready var _animated_sprite = $AnimatedSprite2D

var _shapeCast: ShapeCast2D = null

func _ready():
	print("%s has TYPE: %s" % [name, type])
	if type == enemy_type.BARREL:
		_shapeCast = $ShapeCast2D

func _physics_process(delta):
	_animated_sprite.play("idle")
	
	if type == enemy_type.BARREL:
		_barrel_movement()
	elif type == enemy_type.TNT:
		_tnt_movement()
	elif type == enemy_type.TORCH:
		_torch_movement()

	move_and_slide()

func _barrel_movement():
	if _shapeCast.is_colliding():
		_animated_sprite.play("alert_to_idle")
		#for collision in _shapeCast.collision_result:
			#print("Collided with %s" % collision.collider.name)
	
func _tnt_movement():
	pass
	
func _torch_movement():
	pass
