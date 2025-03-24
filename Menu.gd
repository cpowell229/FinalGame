extends Control


extends Control

func _ready():
	$VBoxContainer/NewGame.text = "New Game"
	$VBoxContainer/LoadGame.text = "Load Game"
	$VBoxContainer/Exit.text = "Exit"

	$VBoxContainer/NewGame.pressed.connect(_on_new_game_pressed)
	$VBoxContainer/LoadGame.pressed.connect(_on_load_game_pressed)
	$VBoxContainer/Exit.pressed.connect(_on_exit_pressed)

func _on_new_game_pressed():
	print("New Game")
	# Replace with your new game logic, like resetting game state or loading a scene
	get_tree().change_scene_to_file("res://scenes/Level1.tscn")

func _on_load_game_pressed():
	print("Load Game")
	# Implement load logic (load from save file, etc.)
	# For now: just go to a dummy load scene
	get_tree().change_scene_to_file("res://scenes/LoadGameScreen.tscn")

func _on_start_game_pressed():
	print("Start Game")
	# Continue from where player left off (placeholder logic)
	get_tree().change_scene_to_file("res://scenes/MainGame.tscn")

func _on_exit_pressed():
	get_tree().quit()
