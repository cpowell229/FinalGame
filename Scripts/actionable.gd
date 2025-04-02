extends Area2D

@export var dialogue_path: String = "res://azrael_dialogue_1.dialogue"
@export var dialogue_start: String = "start"
# Remove or ignore 'dialogue_resource' if the plugin doesn't actually need it:
# @export var dialogue_resource: DialogueResource

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

##func _process(delta):
	##if player_in_range and Input.is_action_just_pressed("ui_accept"):
		# 1) Fix the spelling: use "dialogue_path", not "dialougue_path"
		# 2) Pass correct types: (String, String, Array)
		##DialogueManager.show_dialogue_balloon(dialogue_path, dialogue_start, [])
