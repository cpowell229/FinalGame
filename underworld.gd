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
