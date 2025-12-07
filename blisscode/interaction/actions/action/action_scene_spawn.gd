class_name ActionSceneSpawn extends Action

@export var scene: PackedScene
@export var parent: Node2D

var original_position

func _ready() -> void:
	if parent:
		original_position = parent.position

func enter():
	super.enter()
	if parent:
		if agent is CharacterController and not agent.is_facing_right:
			parent.position.x = -original_position.x
		else:
			parent.position.x = original_position.x

func process(_delta: float) -> Status:
	if scene and parent:
		call_deferred("_spawn_scene")
	return Status.SUCCESS

func _spawn_scene():
	var new_scene = scene.instantiate()
	parent.add_child(new_scene)
