class_name ActionKnockback extends Action

enum KnockbackDirection {
	NONE,
	UP,
	DOWN,
	SIDE
}

@export var body_var: StringName = &"body"
@export var knockback_direction: KnockbackDirection = KnockbackDirection.NONE

func process(_delta: float) -> Status:
	var body = blackboard.get_var(body_var, null)
	if body and body is CharacterController:
		var direction = Vector2.ZERO
		if knockback_direction == KnockbackDirection.UP:
			direction = Vector2.UP
		elif knockback_direction == KnockbackDirection.DOWN:
			direction = Vector2.DOWN
		elif knockback_direction == KnockbackDirection.SIDE:
			if body.is_facing_right:
				direction = Vector2.LEFT
			else:
				direction = Vector2.RIGHT
		if knockback_direction != KnockbackDirection.NONE:
			body.apply_knockback(direction)
	return Status.SUCCESS
