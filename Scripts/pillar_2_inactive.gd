extends Area2D
signal pillar_activated
@onready var prompt_label = $Label
var player_in_range = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	prompt_label.visible = false
	print("Pillar script loaded on:", self.name)

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
		activate_pillar()

func activate_pillar():
	print("Spawning active pillar and removing inactive pillar (", self.name, ")")
	var active_pillar_scene = preload("res://pillar_2_active.tscn")
	var active_pillar = active_pillar_scene.instantiate()

	active_pillar.global_position = global_position
	get_parent().add_child(active_pillar)

	print("New pillar added:", active_pillar.name, "– queue_free on", self.name)
	emit_signal("pillar_activated")
	queue_free()  # Should remove this *inactive* pillar
