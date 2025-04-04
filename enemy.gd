extends CharacterBody2D

var speed = 100
var player_chase = false
var player = null
var health = 100
var in_range = false
var can_take_damage = true
var is_dying = false
var can_attack = true

func _ready():
	$AnimatedSprite2D.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func _physics_process(delta):
	if is_dying:
		return  # Don't move or chase if we're dying

	deal_with_attacks()
	attack()
	var current_anim = $AnimatedSprite2D.animation
	if current_anim in ["Take_hit", "Death", "Attack"]:
		return

	if player_chase and player:
		position += (player.position - position).normalized() * speed * delta
		move_and_collide(Vector2.ZERO)
		$AnimatedSprite2D.play("Walk")

		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("Idle")

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
		health -= 30
		print("Enemy took 30 damage, now at", health)
		can_take_damage = false
		$take_damage_cooldown.start()  # Must be connected
		$AnimatedSprite2D.play("Take_hit")
		if health <= 0:
			health = 0
			is_dying = true
			# Play death anim (don't queue_free yet!)
			$AnimatedSprite2D.play("Death")

func attack():
	if in_range and can_attack and not is_dying:
		can_attack = false  # Start cooldown
		$attack_cooldown.start()
		$AnimatedSprite2D.play("Attack")

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
	if current_anim == "Death":
		queue_free() 
	elif current_anim == "Attack":
		if player and player.has_method("take_damage"):
			player.take_damage(10)
	elif current_anim == "Take_hit" and not is_dying:
		if player_chase and player:
			$AnimatedSprite2D.play("Walk")
		else:
			$AnimatedSprite2D.play("Idle")


func _on_attack_cooldown_timeout() -> void:
	can_attack = true
