extends CharacterBody2D


var speed = 100
var player_chase = false
var player = null
var health = 100
var in_range = false

func _physics_process(delta):
	deal_with_attacks()
	if player_chase:
		position += (player.position - position).normalized() * speed * delta
		move_and_collide(Vector2(0,0)) 
		$AnimatedSprite2D.play("Walk")
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
			
			
	else:
		$AnimatedSprite2D.play("Idle")
		


		
func _on_area_2d_body_entered(body):
	player = body
	player_chase = true


func _on_area_2d_body_exited(body):
	player = null
	player_chase = false


func _on_hitbox_area_entered(body):
	if body.has_method("player"):
		in_range = true


func _on_hitbox_area_exited(body):
	if body.has_method("player"):
		in_range = true
func deal_with_attacks():
	if in_range and Global.is_attacking:
		health = health - 30
		if health <= 0:
			self.queue_free()
		
