extends Area2D

@export var speed = 1000
signal hit
var flipped: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * delta
	pass

func flip():
	speed = -speed
	rotate(PI)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	hide()
	body.hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.


func _on_hidden() -> void:
	queue_free()
	pass # Replace with function body.
