extends CharacterBody2D



var in_range = false
func _ready():
	$AnimatedSprite2D.play("Idle")


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.
