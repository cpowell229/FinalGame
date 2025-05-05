## -------------  LevelManager.gd  ------------------------------------------
extends Node

var levels : Array[String] = [
	"res://Scenes/Levels/game_start.tscn",
	"res://Scenes/Levels/underworld.tscn",
	"res://Scenes/Levels/underworld_2.tscn",
	"res://Scenes/Levels/forest.tscn",
	"res://Scenes/Levels/floating_Island.tscn"
]


# ---------------------------------------------------------------------------
func load_next_level_from(current_path : String) -> void:
	var idx := levels.find(current_path)
	if idx == -1:
		push_error("Scene not found in level list: %s" % current_path)
		return

	var next_idx := idx + 1
	if next_idx >= levels.size():
		_game_complete()
	else:
		get_tree().change_scene_to_file(levels[next_idx])

# ---------------------------------------------------------------------------
func _game_complete() -> void:
	print("🎉 All levels finished!")
	pass
