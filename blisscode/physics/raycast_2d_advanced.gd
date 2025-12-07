class_name RayCast2DAdvanced extends RayCast2D

@export var agent: CharacterController
@export var flip_x: bool = false
@export var flip_y: bool = false

func _ready() -> void:
	if agent:
		agent.facing_direction_changed.connect(_on_facing_direction_changed)

func _on_facing_direction_changed():
	if agent and agent.animated_sprite:
		if agent.animated_sprite.flip_h:
			target_position.x = - target_position.x
			if flip_x:
				position.x = - position.x
			if flip_y:
				position.y = - position.y
		else:
			target_position.x = abs(target_position.x)
			if flip_x:
				position.x = abs(position.x)
			if flip_y:
				position.y = abs(position.y)
