extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_bounce():
	var tween = create_tween()
	var start_pos = position
	var peak_pos = position - Vector2(0, 30)
	
	tween.tween_property(self, "position", peak_pos, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", start_pos, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
