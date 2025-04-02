extends Node2D

var pillar1_activated = false
var pillar2_activated = false

func _ready():
	# Use Callable(...) for Godot 4
	$Pillar.connect("pillar_activated", Callable(self, "_on_pillar1_activated"))
	$Pillar2.connect("pillar_activated", Callable(self, "_on_pillar2_activated"))

func _on_pillar1_activated():
	pillar1_activated = true
	check_pillars()

func _on_pillar2_activated():
	pillar2_activated = true
	check_pillars()

func check_pillars():
	if pillar1_activated and pillar2_activated:
		spawn_azrael()
		spawn_floating_pillar()

func spawn_azrael():
	var azrael_scene = preload("res://Azrael.tscn")
	var azrael = azrael_scene.instantiate()
	azrael.position = Vector2(400, 200)
	add_child(azrael)
func spawn_floating_pillar():
	var pillars = preload("res://floating_pillar.tscn")
	var pillar = pillars.instantiate()
	var pillar2 = pillars.instantiate()
	pillar.position = Vector2(-613, 174)
	pillar2.position = Vector2(-679, 881)
	add_child(pillar)
	add_child(pillar2)
