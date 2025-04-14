extends CharacterBody2D

var speed = 100
var player_chase = false
var player = null
var health = 300
var in_range = false
var can_take_damage = true
var is_dying = false
var can_attack = true
signal dead

func _ready():
	$AnimatedSprite2D.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	$AnimatedSprite2D.play("Front_Idle")

func _physics_process(delta):
	deal_with_attacks()
	attack()
	update_health()
	var current_anim = $AnimatedSprite2D.animation
	if current_anim in ["Death_Right", "Death_Left", "Death_Front", "Death_Back",
	 "Right_Attack", "Left_Attack", "Back_Attack", "Front_Attack",
	 "Hurt_Right", "Hurt_Left", "Hurt_Back", "Hurt_Front"]:
		return
	if player_chase and player:
		position += (player.position - position).normalized() * speed * delta
		move_and_collide(Vector2.ZERO)
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.play("Left_Walk")
		elif (player.position.x - position.x) > 0:
			$AnimatedSprite2D.play("Right_Walk")
		elif (player.position.y - position.y) < 0:
			$AnimatedSprite2D.play("Back_Walk")
		elif (player.position.y - position.y) > 0: 
			$AnimatedSprite2D.play("Front_Walk")
		else:
			if (player.position.x - position.x) < 0:
				$AnimatedSprite2D.play("Left_Idle")
			elif (player.position.x - position.x) > 0:
				$AnimatedSprite2D.play("Right_Idle")
			elif (player.position.y - position.y) < 0:
				$AnimatedSprite2D.play("Front_Idle")
			elif (player.position.y - position.y) > 0: 
				$AnimatedSprite2D.play("Back_Idle")
		

func enemy():
	pass

func _on_area_2d_body_entered(body):
	# Start chasing if it's the player
	if body.has_method("player"):
		player = body
		player_chase = true

func _on_area_2d_body_exited(body):
	# Stop chasing if the player leaves area
	if body.has_method("player"):
		player = null
		player_chase = false

func deal_with_attacks():
	if can_take_damage and in_range and Global.is_attacking and not is_dying:
		health = health - 30
		print("Enemy took 30 damage, now at", health)
		can_take_damage = false
		$take_damage_cooldown.start()
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.play("Hurt_Left")
		elif (player.position.x - position.x) > 0:
			$AnimatedSprite2D.play("Hurt_Right")
		elif (player.position.y - position.y) < 0:
			$AnimatedSprite2D.play("Hurt_Front")
		elif (player.position.y - position.y) > 0: 
			$AnimatedSprite2D.play("Hurt_Back")
		if health <= 0:
			health = 0
			is_dying = true
			if (player.position.x - position.x) < 0:
					$AnimatedSprite2D.play("Death_Left")
			elif (player.position.x - position.x) > 0:
					$AnimatedSprite2D.play("Death_Right")
			elif (player.position.y - position.y) < 0:
					$AnimatedSprite2D.play("Death_Front")
			elif (player.position.y - position.y) > 0: 
					$AnimatedSprite2D.play("Death_Back")
			
			

func attack():
	if in_range and can_attack and not is_dying:
		can_attack = false  
		$attack_cooldown.start()
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.play("Left_Attack")
		elif (player.position.x - position.x) > 0:
			$AnimatedSprite2D.play("Right_Attack")
		elif (player.position.y - position.y) < 0:
			$AnimatedSprite2D.play("Front_Attack")
		elif (player.position.y - position.y) > 0: 
			$AnimatedSprite2D.play("Back_Attack")

func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		in_range = true

func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		in_range = false

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
	

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
				if player and (player.position.x - position.x) < 0:
					$AnimatedSprite2D.play("Left_Idle")
				elif player and (player.position.x - position.x) > 0:
					$AnimatedSprite2D.play("Right_Idle")
				elif player and (player.position.y - position.y) < 0:
					$AnimatedSprite2D.play("Front_Idle")
				elif player and (player.position.y - position.y) > 0:
					$AnimatedSprite2D.play("Back_Idle")

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
			if player and (player.position.x - position.x) < 0:
				$AnimatedSprite2D.play("Left_Idle")
			elif player and (player.position.x - position.x) > 0:
				$AnimatedSprite2D.play("Right_Idle")
			elif player and (player.position.y - position.y) < 0:
				$AnimatedSprite2D.play("Front_Idle")
			elif player and (player.position.y - position.y) > 0:
				$AnimatedSprite2D.play("Back_Idle")

func update_health():
	var healthBar = $HealthBar
	healthBar.value = health 
	if health >= 300:
		healthBar.visible = false
	else:
		healthBar.visible = true
		



func _on_attack_cooldown_timeout() -> void:
	can_attack = true





func _on_heal_timeout() -> void:
	if health < 300:
		health = health + 20
		if health > 300:
			health = 100
	if health <= 0:
		health = 0
