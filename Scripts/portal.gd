extends StaticBody2D
@onready var prompt_label = $Label
var player_in_range = false
signal portal_activated


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.connect("frame_changed", Callable(self, "_on_AnimatedSprite2D_frame_changed"))
	prompt_label.visible = false
	print("Portal loaded:", self.name)
	


func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("E pressed!")
		activate_portal()

func activate_portal():
	print("Switching scenes")
	var active_portal_scene = preload("res://Scenes/pillar_1_active.tscn")
	var active_portal = active_portal_scene.instantiate()
	active_portal.global_position = global_position
	get_parent().add_child(active_portal)
	emit_signal("portal_activated") 
	queue_free()  # Should remove this *inactive* pillar

func handle_animation():
	var current_anim = $AnimatedSprite2D.animation
	if player_in_range and current_anim != "Opening" and current_anim != "Idle":
		$AnimatedSprite2D.play("Opening")
	elif not player_in_range and current_anim != "Closing" and current_anim != "Closed":
		$AnimatedSprite2D.play("Closing")
		

func _on_animated_sprite_2d_animation_finished() -> void:
	var current_anim = $AnimatedSprite2D.animation
	if current_anim == "Opening":
		$AnimatedSprite2D.play("Idle")
	elif current_anim == "Closing":
		$AnimatedSprite2D.play("Closed")


func _on_zone_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = true
		handle_animation()
		prompt_label.visible = true


func _on_zone_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = false
		handle_animation()
		prompt_label.visible = false
