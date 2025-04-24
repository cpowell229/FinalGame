extends CharacterBody2D

var walk_speed = 200
var run_speed = 400
var inventory: Array = []
var health = 100
var player_alive = true
var enemy_in_range = false
var enemy_attack_cooldown = true
var running = false
var last_enemy_body = null
var is_hurt = false
var current_dir             = "Front" 
@onready var actionable_finder: Area2D = $CharacterBody2D/actionable


@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var attacking: bool = false


func _ready() -> void: 
	anim_sprite.play(current_dir + "_Idle")
	anim_sprite.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

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
	new_vel = new_vel.normalized()

	# remember facing even if you stop
	if new_vel.x < 0:
		current_dir = "Left"
	elif new_vel.x > 0:
		current_dir = "Right"
	elif new_vel.y < 0:
		current_dir = "Back"
	elif new_vel.y > 0:
		current_dir = "Front"
	if Global.can_run and running:
		velocity = new_vel * run_speed
	else:
		velocity = new_vel * walk_speed

func _physics_process(delta):
	run()
	move_and_slide()
	enemy_attack()
	attack()
	update_health()
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return
		
			
	if health <= 0:
		player_alive = false
		health = 0
		anim_sprite.play(current_dir + "_Death")
		print("player died...")
		self.queue_free()
		return
	if not attacking and not is_hurt and player_alive:
		_update_movement_animation()
func _update_movement_animation():
	if velocity.length() > 0:
		if Global.can_run and running:
			anim_sprite.play(current_dir + "_Run")
		else:
			anim_sprite.play(current_dir + "_Walk")
	else:
		anim_sprite.play(current_dir + "_Idle")					
func run():
	if Global.can_run and Input.is_action_pressed("run"):
		running = true
	else:
		running = false
func player():
	pass
func enemy_attack():
	if enemy_in_range and enemy_attack_cooldown:
		is_hurt = true
		health = health - 15
		if last_enemy_body:
			var rel = last_enemy_body.global_position - global_position
			if abs(rel.x) > abs(rel.y):
				if rel.x < 0:
					anim_sprite.play("Left_Hurt")
				else:
					anim_sprite.play("Right_Hurt")
			else:
				if rel.y < 0:
					anim_sprite.play("Back_Hurt")
				else:
					anim_sprite.play("Front_Hurt")
		else:
			anim_sprite.play(current_dir + "_Hurt")
		enemy_attack_cooldown = false
		$Attack_Cooldown.start()
		$Hurt.start()
		print("player -15 health")

# This function is called when the player collects a gem.
func add_to_inventory(item):
	inventory.append(item)
	print("Picked up: ", item)

		



func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	if Input.is_action_just_pressed("attack") and not attacking and player_alive:
		attacking = true
		Global.is_attacking = true
		anim_sprite.play(current_dir + "_Attack")
		$Deal_attack.start()
		
	
	

func _on_deal_attack_timeout() -> void:
	$Deal_attack.stop()
	Global.is_attacking = false
	attacking = false


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_range = true


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_range = false

func update_health():
	var healthBar = $HealthBar
	healthBar.value = health 
	if health >= 100:
		healthBar.visible = false
	else:
		healthBar.visible = true
		
func _on_heal_timeout() -> void:
	if health < 100:
		health = health + 20
		if health > 100:
			health = 100
	if health <= 0:
		health = 0


func _on_animated_sprite_2d_animation_finished(anim_name) -> void:
	if anim_name.ends_with("_Attack"):
		attacking = false
		Global.is_attacking = false
	elif anim_name.ends_with("_Hurt"):
		is_hurt = false


func _on_hurt_timeout() -> void:
	is_hurt = false
