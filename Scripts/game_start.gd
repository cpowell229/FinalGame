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
		spawn_portal()
		spawn_enemies()

func spawn_azrael():
	var azrael_scene = preload("res://Scenes/Azrael.tscn")
	var azrael = azrael_scene.instantiate()
	azrael.position = Vector2(400, 200)
	add_child(azrael)
func spawn_floating_pillar():
	var pillars = preload("res://Scenes/floating_pillar.tscn")
	var pillar = pillars.instantiate()
	var pillar2 = pillars.instantiate()
	pillar.position = Vector2(-613, 174)
	pillar2.position = Vector2(-679, 881)
	add_child(pillar)
	add_child(pillar2)
func spawn_portal():
	var portal = preload("res://Scenes/portal.tscn")
	var portalx = portal.instantiate()
	portalx.position = Vector2(1813,2)
	add_child(portalx)
func spawn_enemies():
	## could do a loop but this makes it easier to spawn them in exact places and the loop was buggy
		var enemy = preload("res://skelton_enemy.tscn")
		var enemy1 = enemy.instantiate()
		var enemy2 = enemy.instantiate()
		var enemy3 = enemy.instantiate()
		var enemy4 = enemy.instantiate()
		enemy1.position = Vector2(1346, 379)
		enemy2.position = Vector2(1595, 773)
		enemy3.position = Vector2(1829, 381)
		enemy4.position = Vector2(1666, 179)
		add_child(enemy1)
		add_child(enemy2)
		add_child(enemy3)
		add_child(enemy4)
	
