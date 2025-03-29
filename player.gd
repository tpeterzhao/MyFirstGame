class_name Player
extends Area2D

signal spawn_projectile_signal(position, direction)
signal player_hit_signal

@export var speed = 400
@export var health = 3
@export var damage = 5

var screen_size
var velocity: Vector2 = Vector2.ZERO
var playerActionState:PlayerStateMachine = Player_Idle_State
var playerPreviousActionState: PlayerStateMachine = Player_Idle_State
var playerDirectionState: PlayerStateMachine
## player direction in radiance, 0 for right, pi for left
var playerDirection: float = 0

static var Player_Idle_State: PlayerIdleState = PlayerIdleState.new()
static var Player_Run_State: PlayerRunState = PlayerRunState.new()
static var Player_Hurt_State: PlayerHurtState = PlayerHurtState.new()
static var Player_Death_State: PlayerDeathState = PlayerDeathState.new()
static var Player_Attack_State: PlayerAttackState = PlayerAttackState.new()
static var Player_Face_Right_State: PlayerFaceRightState = PlayerFaceRightState.new()
static var Player_Face_Left_State: PlayerFaceLeftState = PlayerFaceLeftState.new()

static var movement_actions = [
	"move_right",
	"move_left",
	"move_up",
	"move_down",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	##handle_movement_inputs(delta)
	
	# player animation update based on state
	playerActionState.player_update(self, delta)
	playerDirectionState.player_update(self, delta)
	$AnimatedSprite2D.play()
	
	if health <= 0 && playerActionState != Player_Death_State:
		playerActionState = Player_Death_State
		playerActionState.enter_state(self)
	
	# handle input
	playerActionState.player_handle_input(self)
	playerDirectionState.player_handle_input(self)

	process_movement(delta)
	pass

	
func process_movement(delta: float):
	velocity = Vector2.ZERO
	
	## handle edge case of pressing left and right at the same time
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	pass
	
func start(pos):
	position = pos
	playerActionState = self.Player_Idle_State
	playerDirectionState = self.Player_Face_Right_State
	show()
	$CollisionShape2D.disabled = false
	$AttackDefaultTimer.start()

func _on_default_attack_timer_timer_timeout() -> void:
	##action_attack_default()
	print("Time to attack!")
	$AttackPrepareDurationTimer.start()
	$AttackDurationTimer.start()
	playerPreviousActionState = playerActionState
	playerActionState = Player_Attack_State
	pass # Replace with function body.

func _on_attack_prepare_duration_timer_timeout() -> void:
	spawn_projectile_signal.emit($ProjectileSpawnLocation.global_position, playerDirection)
	pass # Replace with function body.
	
func _on_attack_duration_timer_timeout() -> void:
	playerActionState.finish_attack(self)
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	player_hit_signal.emit()
	pass # Replace with function body.
	
func get_sprite() -> AnimatedSprite2D:
	return $AnimatedSprite2D
	
class PlayerIdleState extends PlayerStateMachine:	
	func player_update(player: Player, delta: float) -> void:
		player.get_sprite().animation = "idle"
		pass
		
	func player_handle_input(player: Player) -> void:
		for action in player.movement_actions:
			if Input.is_action_pressed(action):
				player.playerActionState = player.Player_Run_State
				break
		pass
		
class PlayerRunState extends PlayerStateMachine:
	func player_update(player: Player, delta: float) -> void:
		player.get_sprite().animation = "run"
		pass
		
	func player_handle_input(player: Player) -> void:
		for action in player.movement_actions:
			if Input.is_action_pressed(action):
				return
		player.playerActionState = player.Player_Idle_State
		pass

class PlayerHurtState extends PlayerStateMachine:
	func player_update(player: Player, delta: float) -> void:
		player.get_sprite().animation = "hurt"
		## player's health -1 on hit
		player.health =- 1
		pass
		
class PlayerDeathState extends PlayerStateMachine:
	func enter_state(player: Player) -> void:
		for child in player.get_children():
			if child is not AnimatedSprite2D:
				child.set_process(false)
				
	func player_update(player: Player, delta: float) -> void:
		player.get_sprite().animation = "death"
		print("You Died")
		pass

class PlayerAttackState extends PlayerStateMachine:
	func player_update(player: Player, delta: float) -> void:
		##print("Player attacking")
		player.get_sprite().animation = "attack_default"
		pass
		
	func finish_attack(player: Player) -> void:
		##print("Player finish attack")
		player.playerActionState = player.playerPreviousActionState
		pass
			
class PlayerFaceLeftState extends PlayerStateMachine:
	func player_update(player: Player, delta: float) -> void:
		player.get_sprite().flip_h = true
		pass
		
	func player_handle_input(player: Player) -> void:
		if Input.is_action_pressed("move_right") && !Input.is_action_pressed("move_left"):
			player.playerDirectionState = player.Player_Face_Right_State
			player.playerDirection = 0
		pass

class PlayerFaceRightState extends PlayerStateMachine:
	func player_update(player: Player, delta: float) -> void:
		player.get_sprite().flip_h = false
		pass
		
	func player_handle_input(player: Player) -> void:
		if Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right"):
			player.playerDirectionState = player.Player_Face_Left_State
			player.playerDirection = PI
		pass
		
