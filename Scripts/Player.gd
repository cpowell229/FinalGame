extends CharacterBody2D

var speed: float = 600.0
var inventory: Array = []
var health = 100
var player_alive = true
var enemy_in_range = false
var enemy_attack_cooldown = true

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var attacking: bool = false
var current_dir = "none"

func _ready() -> void: 
	$AnimatedSprite2D.play("Idle")

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
	move_and_slide()
	enemy_attack()
	attack()
	if health <= 0:
		player_alive = false
		health = 0
		print("player died...")
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	if not attacking:
		if velocity.length() > 0:
			anim_sprite.play("Run")  # Moving animation
		else:
			anim_sprite.play("Idle")  # Idle animation


func player():
	pass
func enemy_attack():
	if enemy_in_range and enemy_attack_cooldown == true:
		health = health - 15
		enemy_attack_cooldown = false
		$Attack_Cooldown.start()
		print("player -15 health")
	
# This function is called when the player collects a gem.
func add_to_inventory(item):
	inventory.append(item)
	print("Picked up: ", item)

		



func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	if Input.is_action_just_pressed("attack") and not attacking:
		attacking = true
		Global.is_attacking = true
		anim_sprite.play("Attack")
		$Deal_attack.start()

	elif Input.is_action_just_pressed("attack_2") and not attacking:
		attacking = true
		Global.is_attacking = true
		anim_sprite.play("Attack_2")
		$Deal_attack.start()

	elif Input.is_action_just_pressed("attack_3") and not attacking:
		attacking = true
		Global.is_attacking = true
		anim_sprite.play("Attack_3")
		$Deal_attack.start()
		
	
	

func _on_deal_attack_timeout() -> void:
	$Deal_attack.stop()
	Global.is_attacking = false
	attacking = false


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_range = true
