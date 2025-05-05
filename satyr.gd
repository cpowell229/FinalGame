extends CharacterBody2D



var in_range = false
func _ready():
	$AnimatedSprite2D.play("Idle")


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		in_range = true
		Global.active = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		in_range = false
		Global.active = false
