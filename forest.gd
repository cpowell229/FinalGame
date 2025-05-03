extends Node2D

var lever_1 = false
var lever_2 = false
var valid = false

func _ready():
	$ysort/TileMapLayer2/lever_1.connect("activated", Callable(self, "_on_lever_1"))
	$ysort/TileMapLayer2/lever_2.connect("activated", Callable(self, "_on_lever_2"))

func _on_lever_1():
	lever_1 = true
	check()
func _on_lever_2():
	lever_2 = true
	check()
func check():
	if lever_1 and lever_2:
		valid = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if valid:
		Global.levers = true
