extends StaticBody2D
var in_range = false
signal activated
@onready var prompt_label = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("Idle")
	prompt_label.visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_range and Input.is_action_just_pressed("interact"):
		emit_signal("activated")
		action()

func action():
	$AnimatedSprite2D.play("Lit")
	emit_signal("activated")

func _on_activation_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		in_range = true
		prompt_label.visible = true
		$CollisionShape2D.set_deferred("disabled", false)


func _on_activation_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_range = false
		prompt_label.visible = false
