extends Node

# Define an enum for input directions.
enum InputDirection { UP, DOWN, LEFT, RIGHT,  }
var is_attacking = false
var three_pillars = false
var can_run = true
var transition_scene = false
var current_scene = "underworld"
var underworld_door_posx = 0
var underworld_door_posy = 0
var player_start_posx = 0
var player_start_posy = 0
var passive = false

func finish_transition():
	if transition_scene:
		transition_scene = false
		if current_scene == "underworld":
			current_scene = "underworld_2"
		else:
			current_scene = "underworld"
	
