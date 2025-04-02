extends CharacterBody2D

@export var speed: float = 300.0
@export var inventory: Array = []
@export var health = 100
@export var player_alive = true
@export var enemy_in_range = false
@export var enemy_attack_cooldown = true

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var attacking: bool = false

func _ready() -> void:
	add_to_group("player")  # So that coins and the vampire can detect the player
	anim_sprite.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D_animation_finished"))

func move(direction):
	if direction == null:
		velocity = Vector2.ZERO
		return

	var new_vel = Vector2.ZERO
	match direction:
		Global.InputDirection.LEFT:
			new_vel.x = -1
		Global.InputDirection.RIGHT:
			new_vel.x = 1
		Global.InputDirection.UP:
			new_vel.y = -1
		Global.InputDirection.DOWN:
			new_vel.y = 1
	velocity = new_vel * speed

func _physics_process(delta):
	# If the attack action is triggered and we're not already attacking, play the attack animation.
	if Input.is_action_just_pressed("attack") and not attacking:
		attacking = true
		Global.is_attacking = true
		anim_sprite.play("Attack")
		$Deal_attack.start()
	if Input.is_action_just_pressed("attack_2") and not attacking:
		attacking = true
		Global.is_attacking = true
		anim_sprite.play("Attack_2")
		$Deal_attack.start()
	if Input.is_action_just_pressed("attack_3") and not attacking:
		attacking = true
		Global.is_attacking = true
		anim_sprite.play("Attack_3")
		$Deal_attack.start()
	move_and_slide()
	enemy_attack()
	if health <= 0:
		player_alive = false
		health = 0
		print("player died...")
	
	# Flip the sprite based on movement direction.
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	# Only update the default animations if not currently attacking.
	if not attacking:
		if velocity.length() > 0:
			anim_sprite.play("Run")  # Moving animation
		else:
			anim_sprite.play("Idle")  # Idle animation

# This callback resets the attack state when the attack animation finishes.
func _on_AnimatedSprite2D_animation_finished():
	if attacking and anim_sprite.animation == "Attack":
		attacking = false
	if attacking and anim_sprite.animation == "Attack_2":
		attacking = false
	if attacking and anim_sprite.animation == "Attack_3":
		attacking = false
func player():
	pass
func enemy_attack():
	if enemy_in_range and enemy_attack_cooldown == true:
		health = health - 15
		enemy_attack_cooldown == false
		$Attack_Cooldown.start()
		print("player -15 health")
	
# This function is called when the player collects a gem.
func add_to_inventory(item):
	inventory.append(item)
	print("Picked up: ", item)


func _on_hitbox_area_entered(body):
	if body.has_method("enemy"):
		enemy_in_range = true


func _on_hitbox_area_exited(body):
	if body.has_method("enemy"):
		enemy_in_range = false


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true


func _on_deal_attack_timeout() -> void:
	$Deal_attack.stop()
	Global.is_attacking = false
