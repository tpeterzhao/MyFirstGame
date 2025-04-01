extends Area2D

@export var speed = 2000
@export var damage: int = 5
var flipped: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * delta * cos(rotation)
	position.y += speed * delta * sin(rotation)
	pass

func flip():
	speed = -speed
	rotate(PI)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(damage)
	## remove projectile on hit
	$CollisionShape2D.set_deferred("disabled", true)
	hide()
	pass # Replace with function body.


func _on_hidden() -> void:
	queue_free()
	pass # Replace with function body.
