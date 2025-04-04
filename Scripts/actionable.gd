extends Area2D


@export var dialogue_start: String = "start"
# Remove or ignore 'dialogue_resource' if the plugin doesn't actually need it:
@export var dialogue_resource: DialogueResource

var player_in_range = false
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
func _physics_process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("ui_accept"):
		DialogueManager.show_dialogue_balloon(load("res://azrael_dialogue_1.dialogue"), "start")
