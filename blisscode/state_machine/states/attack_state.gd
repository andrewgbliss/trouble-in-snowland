class_name AttackState extends MoveState

@export var left_hand_attack_animation: String = "attack_left_hand"
@export var right_hand_attack_animation: String = "attack_right_hand"
@export var attack_spawn_position: Node2D

var cooldown = false
var attack_rate_time_elapsed: float = 0.0
var attack_rate: float = 0.0

var attack_item: Item

func _process(delta: float) -> void:
	if cooldown:
		attack_rate_time_elapsed += delta
		if attack_rate_time_elapsed >= attack_rate:
			cooldown = false
			attack_rate_time_elapsed = 0

func enter():
	super.enter()
	var hand_direction = state_machine.shared_data["hand_direction"]
	if hand_direction == "right":
		attack_item = parent.character.equipment.right_hand
	if attack_item:
		attack_rate = attack_item.attack_rate
	else:
		attack_item = parent.character.equipment.left_hand
	if attack_item:
		attack_rate = attack_item.attack_rate
	if attack_rate == 0.0:
		attack_rate = 0.5

func process_input(event: InputEvent) -> void:
	if parent.paralyzed:
		return
	if event.is_action_pressed("dash"):
		parent.dash()
	if event.is_action_pressed("jump"):
		parent.jump()
	if event.is_action_pressed("change_gravity_dir"):
		GameManager.toggle_anti_gravity()

func process_physics(delta: float) -> void:
	super.process_physics(delta)
	var did_attack = false
	if not cooldown:
		if parent.controls.is_attacking_left_hand():
			did_attack = true
			play_animation_name(left_hand_attack_animation, attack_item == null)
			attack_ranged_weapon(attack_item, parent.controls.get_aim_direction())
			cooldown = true
			# parent.attack_momentum()
		elif parent.controls.is_attacking_right_hand():
			did_attack = true
			play_animation_name(right_hand_attack_animation, attack_item == null)
			attack_ranged_weapon(attack_item, parent.controls.get_aim_direction())
			cooldown = true
			# parent.attack_momentum()
	if not did_attack and not attack_item and is_animation_finished:
		state_machine.dispatch("attack_finished")
		
func attack_ranged_weapon(item: RangedWeapon, direction: Vector2):
	if not item or (!item.unlimited_ammo and item.ammo <= 0):
		return
	if item.screen_shake_amount > 0.0:
		ScreenShake.apply_shake(item.screen_shake_amount, 2.0, 10.0)
	if item.spread == 1:
		if not item.unlimited_ammo:
			item.ammo -= 1
			# Single projectile - normal behavior
		var attack_position = parent.global_position + attack_spawn_position.position
		var new_position = attack_position
		if parent is CharacterController and not parent.is_facing_right:
			new_position.x = parent.global_position.x - attack_spawn_position.position.x
		SpawnManager.spawn_projectile(item.projectile, new_position, direction)
	else:
		# Multiple projectiles with spread
		for i in range(item.spread):
			var spread_offset = 0.0
			if item.spread > 1:
				# Calculate spread offset based on projectile index
				var half_spread = (item.spread - 1) * 0.5
				spread_offset = (i - half_spread) * item.spread_angle
			
				# Calculate spread direction
				var spread_direction = direction.rotated(spread_offset)
			
				# Calculate spread position (offset perpendicular to direction)
				var perpendicular = Vector2(-direction.y, direction.x)
				var attack_position = parent.global_position + attack_spawn_position.global_position
				var new_position = attack_position
				if parent is CharacterController and not parent.is_facing_right:
					new_position.x = - attack_position.x
				var spread_position = new_position + (perpendicular * spread_offset * 50.0) # 50.0 is a distance multiplier
						
				if not item.unlimited_ammo:
					item.ammo -= 1
				SpawnManager.spawn_projectile(item.projectile, spread_position, spread_direction)
				
	# TODO: Implement ammo changed signal
	# parent.ammo_changed.emit(item, item.ammo)
