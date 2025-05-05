extends StaticBody2D
var in_range = false
signal activated
var active = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("Idle")
	connect("animation_finished", Callable(self, "_on_animated_sprite_2d_animation_finished()"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.three_pillars:
		action()


func action():
	if in_range:
		if $AnimatedSprite2D.animation != "Opening":
			$AnimatedSprite2D.play("Opening")
			
			

func _on_interaction_zone_body_entered(body):
	if body.name == "Player":
		in_range = true
		if Global.three_pillars:
			$CollisionShape2D.set_deferred("disabled", true)
		else:
			$CollisionShape2D.set_deferred("disabled", false)
			


func _on_interaction_zone_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_range = false


func _on_animated_sprite_2d_animation_finished() -> void:
	pass
