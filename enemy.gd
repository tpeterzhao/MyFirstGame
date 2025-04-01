class_name Enemy
extends RigidBody2D

var enemyState: StateMachine = Enemy_Run_State
var enemyVelocity: Vector2
@export var defaultSpeed: float = randf_range(100.0, 200.0)
@export var attackSpeed: float = 400
@export var attackRange: float = 400
@export var enemyHealth: int = 3
signal enemy_damage_taken_signal


static var Enemy_Run_State: StateMachine = EnemyRunState.new()
static var Enemy_Attack_State: StateMachine = EnemyAttackState.new()
# Called when the node enters the scene tree for the first time.

func _init() -> void:
	
	pass
	
func _ready() -> void:
	set_velocity(defaultSpeed)
	
	pass # Replace with function body.

func set_velocity(velocity: float) -> void:
	enemyVelocity = Vector2(velocity, 0)
	linear_velocity = enemyVelocity.rotated(rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	## get player position from main
	var playerPosition = get_parent().playerPosition
	enemyState.enemy_update(self, playerPosition, delta)
	pass
	
func _physics_process(delta: float) -> void:
	enemyState.enemy_physics_update(self, delta)
	pass

func take_damage(amount: int) -> void:
	print("Enemy taken ", amount, "damage")
	enemyHealth -= amount
	## fire damage taken signal for UI to update
	enemy_damage_taken_signal.emit()
	check_for_enemy_death()
	pass
	
func check_for_enemy_death() -> void:
	if enemyHealth <= 0:
		enemy_die()
	pass
	
func enemy_die() -> void:
	print("enemy died")
	hide()
	pass

func get_sprite() -> AnimatedSprite2D:
	return $AnimatedSprite2D

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	pass # Replace with function body.

func _on_hidden() -> void:
	queue_free()
	pass # Replace with function body.
	
class EnemyRunState extends StateMachine:
	func enemy_update(enemy: Enemy, playerPosition: Vector2, delta: float) -> void:
		enemy.get_sprite().animation = "move"
		enemy.get_sprite().play()
		pass
		
	func enemy_physics_update(enemy:Enemy, delta: float) -> void:
		var playerPosition = enemy.get_parent().playerPosition
		enemy.set_velocity(enemy.defaultSpeed)
		enemy.look_at(playerPosition)
		var playerDistance = enemy.position.distance_to(playerPosition)
		if playerDistance < enemy.attackRange:
			enemy.enemyState = enemy.Enemy_Attack_State
			pass
		pass
		
class EnemyAttackState extends StateMachine:
	func enemy_update(enemy: Enemy, playerPosition: Vector2, delta: float) -> void:
		enemy.get_sprite().animation = "attack"
		enemy.get_sprite().play()
		pass
		
	func enemy_physics_update(enemy: Enemy, delta: float) -> void:
		enemy.set_velocity(enemy.attackSpeed)
		var playerPosition = enemy.get_parent().playerPosition
		var playerDistance = enemy.position.distance_to(playerPosition)
		if playerDistance > enemy.attackRange:
			enemy.enemyState = enemy.Enemy_Run_State
			pass
		pass
