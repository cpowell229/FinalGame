extends Node2D



var pillar1_activated = false
var pillar2_activated = false
var pillar3_activated = false
var valid = false

func _ready():
	$Ground/Structures/p1.connect("activated", Callable(self, "_on_pillar1_activated"))
	$Ground/Structures/p2.connect("activated", Callable(self, "_on_pillar2_activated"))
	$Ground/Structures/p3.connect("activated", Callable(self, "_on_pillar3_activated"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if valid:
		Global.three_pillars = true
		transition()
		

func _on_pillar1_activated():
	pillar1_activated = true
	check_pillars()
func _on_pillar2_activated():
	pillar2_activated = true
	check_pillars()
func _on_pillar3_activated():
	pillar3_activated = true
	check_pillars()

func check_pillars():
	if pillar1_activated and pillar2_activated and pillar3_activated:
		valid = true


func _on_transition_body_entered(body):
	if body.has_method("player"):
		Global.transition_scene = true


func _on_transition_body_exited(body):
	if body.has_method("player"):
		Global.transition_scene = false
func transition():
	if Global.transition_scene:
		if Global.current_scene == "underworld":
			get_tree().change_scene_to_file("res://underworld_2.tscn")
			Global.finish_transition()
