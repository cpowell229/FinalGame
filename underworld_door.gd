extends Area2D
var in_range = false
signal activated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("Idle")
	connect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished()"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	action()

func action():
	if in_range:
		if $AnimatedSprite2D.animation != "Opening":
			$AnimatedSprite2D.play("Opening")

func _on_interaction_zone_body_entered(body):
	if body.name == "Player":
		in_range = true


func _on_interaction_zone_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_range = false


func _on_animated_sprite_2d_animation_finished() -> void:
	pass
