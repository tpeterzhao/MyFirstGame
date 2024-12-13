extends Node

@export var enemy_scene: PackedScene
@export var projectile_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
func game_over():
	$EnemySpawnTimer.stop()
	
func new_game():
	$Player.start($StartPosition.position)
	$EnemySpawnTimer.start()


func _on_enemy_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	
	var enemy_spawn_location = $EnemySpawnPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	
	var direction = enemy_spawn_location.rotation + PI / 2
	
	enemy.position = enemy_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)
	
	add_child(enemy)
	pass # Replace with function body.

func spawn_projectile():
	var projectile = projectile_scene.instantiate()
	
	var spawn_location = $Player/ProjectileSpawnLocation.global_position
	
	projectile.position = spawn_location
	if $Player.flipped:
		projectile.flip()
	
	add_child(projectile)
	print("spawn projectile")
	pass


func _on_player_player_hit_signal() -> void:
	print("Player died!")
	pass # Replace with function body.
