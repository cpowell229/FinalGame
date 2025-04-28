extends Area2D
signal activated
var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("Idle")
	$AnimatedSprite2D2.play("Closed")
	connect("animation_finished", Callable(self, "_on_animated_sprite_2d_2_animation_finished()")) 



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.levers:
		action()


func action():
		if $AnimatedSprite2D2.animation != "Opening":
			$AnimatedSprite2D2.play("Opening")
			


func _on_animated_sprite_2d_2_animation_finished() -> void:
	if $AnimatedSprite2D2.animation == "Opening":
		$AnimatedSprite2D.play("Open")
		
