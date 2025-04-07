extends Area2D


@export var dialogue_start: String = "start"
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
	var resource = preload("res://azrael_dialogue_1.dialogue")
	if player_in_range and Input.is_action_just_pressed("ui_accept"):
		DialogueManager.show_example_dialogue_balloon(resource, "start")
