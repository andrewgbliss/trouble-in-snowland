class_name ActionBodyDamage extends Action

@export var body_var: StringName = &"body"
@export var damage: int = 1

func process(_delta: float) -> Status:
	var body = blackboard.get_var(body_var, null)
	if body and body is CharacterController:
		body.take_damage(damage)
	return Status.SUCCESS
