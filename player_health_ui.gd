extends Control

@export var heart_full: Texture2D
@export var heart_empty: Texture2D
var current_health: int = 3

@onready var heart_container = $HBoxContainer

func _ready() -> void:
	update_max_health(3)
	update_health(3)
	pass
	
func update_max_health(max_health: int):
	for i in range(max_health):
		var heart = TextureRect.new()
		heart.texture = heart_full
		heart.custom_minimum_size = Vector2(32,32)
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		heart.expand_mode = false
		heart_container.add_child(heart)
	
func update_health(new_health: int):
	print("Player health UI updated")
	current_health = new_health
	for i in range(heart_container.get_child_count()):
		var heart = heart_container.get_child(i)
		if i < current_health:
			heart.texture = heart_full  # Full heart
		else:
			heart.texture = heart_empty  # Empty heart
