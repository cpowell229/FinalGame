extends Area2D
@onready var prompt_label = $Label
var player_in_range = false
signal portal_activated


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("Opening")
	$AnimatedSprite2D.connect("frame_changed", Callable(self, "_on_AnimatedSprite2D_frame_changed"))
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	prompt_label.visible = false
	print("Portal loaded:", self.name)
	

func _on_AnimatedSprite2D_frame_changed():
	var sprite = $AnimatedSprite2D
	var current_anim = sprite.animation
	var current_frame = sprite.frame
	var total_frames = sprite.sprite_frames.get_frame_count(current_anim)

	# If we've reached the last frame of "Appear," switch to "Idle"
	if current_anim == "Opening" and current_frame == total_frames - 1:
		sprite.play("Idle")

func _on_body_entered(body):
	if body.name == "Player":
		print("Player entered the collision of:", self.name)
		player_in_range = true
		prompt_label.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		print("Player exited the collision of:", self.name)
		player_in_range = false
		prompt_label.visible = false

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
