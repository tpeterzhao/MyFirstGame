extends Node

@export var enemy_scene: PackedScene
@export var projectile_scene: PackedScene
var playerPosition: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	playerPosition = $Player.position
	pass
	
func game_over():
	$EnemySpawnTimer.stop()
	# Show Game Over UI
	#var game_over_scene = preload("res://GameOverScreen.tscn").instantiate()
	#get_tree().get_root().add_child(game_over_scene)
	# Optionally, you can also disable player controls or pause the game
	get_tree().paused = true
	print("Game Over!")

func new_game():
	$Player.start($StartPosition.position)
	playerPosition = $StartPosition.position
	$EnemySpawnTimer.start()
	
	# Make sure the game is not paused
	get_tree().paused = false

func _on_enemy_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	var enemy_spawn_location = $EnemySpawnPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	
	var direction = enemy_spawn_location.rotation + PI / 2
	enemy.position = enemy_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	
	add_child(enemy)
	#print("Enemy spawned!")
	pass

func spawn_projectile_signal_recieved(position, direction):
	var projectile = projectile_scene.instantiate()	
	projectile.position = position
	projectile.rotation = direction
	
	add_child(projectile)
	#print("Spawn projectile")

# When the player dies or the game ends
func _on_player_game_over_signal() -> void:
	game_over()
	pass


func _on_player_player_health_update_signal(amount: Variant) -> void:
	print("Main got signal")
	$UI/PlayerHealthUI.update_health(amount)
	pass # Replace with function body.
