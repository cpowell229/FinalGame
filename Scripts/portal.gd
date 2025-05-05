extends StaticBody2D
@onready var prompt_label = $Label
var player_in_range = false
signal portal_activated


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("Closed")
	$AnimatedSprite2D.connect("frame_changed", Callable(self, "_on_AnimatedSprite2D_frame_changed"))
	prompt_label.visible = false
	print("Portal loaded:", self.name)
	


func _process(delta):
	if Global.active:
		if player_in_range and Input.is_action_just_pressed("interact"):
			print("E pressed!")
			activate_portal()

func activate_portal():
	var here := get_tree().current_scene.scene_file_path
	LevelManager.load_next_level_from(here)

func handle_animation():
	if Global.active:
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
		if Global.active:
			prompt_label.visible = true


func _on_zone_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = false
		handle_animation()
		if Global.active:
			prompt_label.visible = false
