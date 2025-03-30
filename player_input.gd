extends Node2D

@onready var _player_character = get_parent() as CharacterBody2D

func _process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		_player_character.move(Global.InputDirection.LEFT)
	elif Input.is_action_pressed("move_right"):
		_player_character.move(Global.InputDirection.RIGHT)
	elif Input.is_action_pressed("move_up"):
		_player_character.move(Global.InputDirection.UP)
	elif Input.is_action_pressed("move_down"):
		_player_character.move(Global.InputDirection.DOWN)
	else:
		_player_character.move(null)
