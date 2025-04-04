extends Node2D
var in_range = false
func _ready():
	# 1. Play the "Appear" animation immediately
	$AnimatedSprite2D.play("Appear")
	
	# 2. Connect "frame_changed" in code, since it's not exposed in the Editor
	$AnimatedSprite2D.connect("frame_changed", Callable(self, "_on_AnimatedSprite2D_frame_changed"))

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


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass
		
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass
