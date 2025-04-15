extends CharacterBody2D

var speed = 15

var player_chase = false
var player = null
var health = 300
var in_range = false
var can_take_damage = true
var is_dying = false
var can_attack = true
var return_to = false
signal dead

@export var group_name : String = "marker_group"
 
var positions : Array 
var temp_positions : Array
var current_position : Marker2D
 
var direction : Vector2 = Vector2.ZERO
var is_idling = false
var idle_animation_list = ["Front_Idle", "Left_Idle", "Right_Idle", "Back_Idle"]
var idle_animation_index = 0
 
func _ready():
	positions = get_tree().get_nodes_in_group(group_name)
	_get_positions()
	_get_next_position()

func _physics_process(delta):
	if is_idling:
		return
	deal_with_attacks()
	attack()
	update_health()
	
	# Skip movement when special animations are active
	var current_anim = $AnimatedSprite2D.animation
	if current_anim in ["Death_Right", "Death_Left", "Death_Front", "Death_Back",
	 "Right_Attack", "Left_Attack", "Back_Attack", "Front_Attack",
	 "Hurt_Right", "Hurt_Left", "Hurt_Back", "Hurt_Front"]:
		return
	
	var movement_direction = Vector2.ZERO
	
	if player_chase and player:
		# CHASE MODE: Move towards the player
		var diff = player.position - position
		movement_direction = diff.normalized()
		position += movement_direction * speed * delta
		move_and_collide(movement_direction * speed * delta)
		
		# Set animation based on dominant movement axis
		if abs(diff.x) > abs(diff.y):
			if diff.x < 0:
				$AnimatedSprite2D.play("Left_Walk")
			else:
				$AnimatedSprite2D.play("Right_Walk")
		else:
			if diff.y < 0:
				$AnimatedSprite2D.play("Back_Walk")
			else:
				$AnimatedSprite2D.play("Front_Walk")
	else:
		# WANDERING MODE: Move towards current marker
		if current_position:
			var diff = current_position.position - position
			movement_direction = diff.normalized()
			position += movement_direction * speed * delta
			move_and_collide(movement_direction * speed * delta)
			
			# When near the target marker, get the next one
			if position.distance_to(current_position.position) < 10:
				_get_next_position()
			
			# Set animation similar to chase mode, based on direction
			if abs(diff.x) > abs(diff.y):
				if diff.x < 0:
					$AnimatedSprite2D.play("Left_Walk")
				else:
					$AnimatedSprite2D.play("Right_Walk")
			else:
				if diff.y < 0:
					$AnimatedSprite2D.play("Back_Walk")
				else:
					$AnimatedSprite2D.play("Front_Walk")
		else:
			# Fallback if for some reason no marker is available
			$AnimatedSprite2D.play("Right_Idle")

func enemy():
	pass

func _get_positions():
	temp_positions = positions.duplicate()
	temp_positions.shuffle()
 
func _get_next_position():
	# Ensure we have valid marker positions.
	if temp_positions.is_empty():
		_get_positions()
	if not temp_positions.is_empty():
		current_position = temp_positions.pop_front()
		# Set the initial direction toward the next marker
		direction = (current_position.position - position).normalized()

func deal_with_attacks():
	if can_take_damage and in_range and Global.is_attacking and not is_dying:
		health -= 30
		print("Enemy took 30 damage, now at", health)
		can_take_damage = false
		$take_damage_cooldown.start()
		if player:
			var diff = player.position - position
			if diff.x < 0:
				$AnimatedSprite2D.play("Hurt_Left")
			elif diff.x > 0:
				$AnimatedSprite2D.play("Hurt_Right")
			elif diff.y < 0:
				$AnimatedSprite2D.play("Hurt_Front")
			elif diff.y > 0:
				$AnimatedSprite2D.play("Hurt_Back")
		if health <= 0:
			health = 0
			is_dying = true
			if player:
				var diff = player.position - position
				if diff.x < 0:
					$AnimatedSprite2D.play("Death_Left")
				elif diff.x > 0:
					$AnimatedSprite2D.play("Death_Right")
				elif diff.y < 0:
					$AnimatedSprite2D.play("Death_Front")
				elif diff.y > 0:
					$AnimatedSprite2D.play("Death_Back")
			
func attack():
	if in_range and can_attack and not is_dying:
		can_attack = false  
		$attack_cooldown.start()
		if player:
			var diff = player.position - position
			if diff.x < 0:
				$AnimatedSprite2D.play("Left_Attack")
			elif diff.x > 0:
				$AnimatedSprite2D.play("Right_Attack")
			elif diff.y < 0:
				$AnimatedSprite2D.play("Front_Attack")
			elif diff.y > 0:
				$AnimatedSprite2D.play("Back_Attack")
func update_health():
	var healthBar = $HealthBar
	healthBar.value = health 
	if health >= 300:
		healthBar.visible = false
	else:
		healthBar.visible = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_chase = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player = null
		player_chase = false


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		in_range = true


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		in_range = false


func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true


func _on_attack_cooldown_timeout() -> void:
	can_attack = true


func _on_heal_timeout() -> void:
	if health < 100:
		health = health + 20
		if health > 100:
			health = 100
	if health <= 0:
		health = 0


func _on_animated_sprite_2d_animation_finished() -> void:
	var current_anim = $AnimatedSprite2D.animation
	print("Animation finished:", current_anim)
	
	if current_anim in ["Death_Right", "Death_Left", "Death_Front", "Death_Back"]:
		emit_signal("dead")
		queue_free()
	elif current_anim in ["Right_Attack", "Left_Attack", "Back_Attack", "Front_Attack"]:
		if player_chase and player:
				if (player.position.x - position.x) < 0:
					$AnimatedSprite2D.play("Left_Walk")
				elif (player.position.x - position.x) > 0:
					$AnimatedSprite2D.play("Right_Walk")
				elif (player.position.y - position.y) < 0:
					$AnimatedSprite2D.play("Front_Walk")
				elif (player.position.y - position.y) > 0:
					$AnimatedSprite2D.play("Back_Walk")
		else:
			start_idle_cycle()

	elif current_anim in ["Hurt_Right", "Hurt_Left", "Hurt_Front", "Hurt_Back"] and not is_dying:
		# After hurt animation, go back to chase or idle
		if player_chase and player:
			if (player.position.x - position.x) < 0:
				$AnimatedSprite2D.play("Left_Walk")
			elif (player.position.x - position.x) > 0:
				$AnimatedSprite2D.play("Right_Walk")
			if (player.position.y - position.y) < 0:
				$AnimatedSprite2D.play("Front_Walk")
			elif (player.position.y - position.y) > 0:
				$AnimatedSprite2D.play("Back_Walk")
		else:
			start_idle_cycle()


func _on_return_to_wander_timeout() -> void:
	return_to = true
	$return_to_wander.stop()


func start_idle_cycle():
	is_idling = true
	idle_animation_index = 0
	$IdleStop.start()         # IdleTimer's wait time should be set to 3 seconds
	$IdleCycle.start()    # IdleCycleTimer's wait time should be set to a short interval (e.g., 0.5 seconds)
	$AnimatedSprite2D.play(idle_animation_list[idle_animation_index])
func _on_idle_stop_timeout() -> void:
	if is_idling:
		$AnimatedSprite2D.play(idle_animation_list[idle_animation_index])
		idle_animation_index = (idle_animation_index + 1) % idle_animation_list.size()



func _on_idle_cycle_timeout() -> void:
	is_idling = false
	$IdleCycle.stop()
	idle_animation_index = 0
	# Resume wandering by selecting the next marker
	_get_next_position()
