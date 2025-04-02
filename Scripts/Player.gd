extends CharacterBody2D

@export var speed: float = 300.0
@export var inventory: Array = []
@export var health = 100
@export var player_alive = true
@export var enemy_in_range = false
@export var enemy_attack_cooldown = true

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_attacking: bool = false

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

func _physics_process(delta: float) -> void:
	# If the attack action is triggered and we're not already attacking, play the attack animation.
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		anim_sprite.play("Attack")
	
	# Continue physics processing regardless of attack state.
	move_and_slide()
	
	# Flip the sprite based on movement direction.
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	# Only update the default animations if not currently attacking.
	if not is_attacking:
		# Update animation based on whether we're moving.
		if velocity.length() > 0:
			anim_sprite.play("Run")  # Moving animation
		else:
			anim_sprite.play("Idle")  # Idle animation

# This callback resets the attack state when the attack animation finishes.
func _on_AnimatedSprite2D_animation_finished():
	if is_attacking and anim_sprite.animation == "Attack":
		is_attacking = false

func _on_Hitbox(body):
	if body.has_method("enemy"):
		enemy_in_range = true

func _out_of_Hitbox(body):
	if body.has_method("enemy"):
		enemy_in_range = false

func enemy_attack():
	if enemy_in_range:
		print("player -15 health")
	
# This function is called when the player collects a gem.
func add_to_inventory(item):
	inventory.append(item)
	print("Picked up: ", item)
