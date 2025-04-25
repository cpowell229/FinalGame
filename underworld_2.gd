extends Node2D



var kill1 = false
var kill2 = false
var kill3 = false
var kill4 = false
var valid = false

func _ready():
	$CharacterBody2D2.connect("dead", Callable(self, "_on_pillar4_activated"))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if valid:
		spawn()
		valid = false

func _on_pillar1_activated():
	kill1 = true
	check_pillars()
func _on_pillar2_activated():
	kill2 = true
	check_pillars()
func _on_pillar3_activated():
	kill3 = true
	check_pillars()
func _on_pillar4_activated():
	kill4 = true
	check_pillars()

func check_pillars():
	if kill1 and kill2 and kill3 and kill4:
		valid = true
func spawn():
	var azrael_scene = preload("res://Scenes/Azrael.tscn")
	var azrael = azrael_scene.instantiate()
	azrael.position = Vector2(700, -200)
	add_child(azrael)
