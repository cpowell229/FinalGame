## -----------------------  LevelManager.gd  -------------------------------
extends Node

var levels : Array[String] = [
	"res://Scenes/Levels/game_start.tscn",
	"res://Scenes/Levels/underworld.tscn",
	"res://Scenes/Levels/underworld_2.tscn",
	"res://Scenes/Levels/forest.tscn",
	"res://Scenes/Levels/floating_Island.tscn"
]

# -------------------------------------------------------------------------
#  Public “where‑am‑I?” fields that other scripts (like Player.gd) can read
# -------------------------------------------------------------------------
var current_index : int    = 0      ### NEW
var current_path  : String = ""     ### NEW

# -------------------------------------------------------------------------
#  Main helper — handles ALL scene changes in one place
# -------------------------------------------------------------------------
func _go_to(idx: int) -> void:      ### NEW helper
	current_index = idx             # ❶ keep index in sync
	current_path  = levels[idx]     # ❷ keep path  in sync
	get_tree().change_scene_to_file(current_path)

# -------------------------------------------------------------------------
func load_next_level_from(current_path_in : String) -> void:
	var idx := levels.find(current_path_in)
	if idx == -1:
		push_error("Scene not found in level list: %s" % current_path_in)
		return

	var next_idx := idx + 1
	if next_idx >= levels.size():
		_game_complete()
	else:
		_go_to(next_idx)            ### use the helper so tracking stays correct

# -------------------------------------------------------------------------
func _game_complete() -> void:
	print("🎉 All levels finished!")
	# e.g. _go_to(0) to restart, or load a credits scene here
