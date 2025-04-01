extends Node2D

func _ready():
	# Start playing "Appear" immediately
	$AnimatedSprite2D.play("Appear")

func _on_AnimatedSprite2D_frame_changed():
	var sprite = $AnimatedSprite2D
	var current_anim = sprite.animation
	var current_frame = sprite.frame
	var total_frames = sprite.sprite_frames.get_frame_count(current_anim)

	# If we've reached the last frame of "Appear," switch to "Idle"
	if current_anim == "Appear" and current_frame == total_frames - 1:
		sprite.play("Idle")

	# If we've reached the last frame of "Disappear," remove Azrael from the scene
	elif current_anim == "Disappear" and current_frame == total_frames - 1:
		queue_free()

# Call this after the player's dialogue finishes:
func disappear_after_dialogue():
	$AnimatedSprite2D.play("Disappear")
