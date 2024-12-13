class_name Player
extends Area2D

signal spawn_projectile_signal
signal player_hit_signal

@export var speed = 400
var screen_size
var velocity: Vector2 = Vector2.ZERO
var playerState:StateMachine

static var Player_Idle_Right_State: PlayerIdleRightState = PlayerIdleRightState.new()
static var Player_Idle_Left_State: PlayerIdleLeftState = PlayerIdleLeftState.new()
static var Player_Run_Right_State: PlayerRunRightState = PlayerRunRightState.new()
static var Player_Run_Left_State: PlayerRunLeftState = PlayerRunLeftState.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	##handle_movement_inputs(delta)
	
	# player animation update based on state
	playerState.player_update(self, delta)
	$AnimatedSprite2D.play()
	
	# handle input
	playerState.player_handle_input(self)

	process_movement(delta)
	pass

	
func process_movement(delta: float):
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	pass
	
func start(pos):
	position = pos
	playerState = self.Player_Idle_Right_State
	show()
	$CollisionShape2D.disabled = false
	$AttackDefaultTimer.start()

func _on_timer_default_timer_timeout() -> void:
	##action_attack_default()
	pass # Replace with function body.
	
func action_attack_default():
	$AnimatedSprite2D.animation = "attack_default"
	$AnimatedSprite2D.flip_h = velocity.x < 0
	spawn_projectile_signal.emit()
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack_default":
		
		pass # Replace with function body.
	pass

func _on_body_entered(body: Node2D) -> void:
	player_hit_signal.emit()
	pass # Replace with function body.
	
func get_sprite() -> AnimatedSprite2D:
	return $AnimatedSprite2D
	
	
	
class PlayerIdleRightState extends PlayerStateMachine:	
	func player_update(player: Player, delta: float) -> void:
		player.get_sprite().animation = "idle"
		player.get_sprite().flip_h = false
		player.velocity.x = 0
		player.velocity.y = 0
		
		pass
		
	func player_handle_input(player: Player) -> void:
		if Input.is_action_pressed("move_right"):
			print("Player move right")
			player.playerState = player.Player_Run_Right_State
		if Input.is_action_pressed("move_left"):
			player.playerState = player.Player_Run_Left_State
		pass
		
class PlayerIdleLeftState extends PlayerStateMachine:
	func player_update(player: Player, delta: float) -> void:
		player.get_sprite().animation = "idle"
		player.get_sprite().flip_h = true
		player.velocity.x = 0
		player.velocity.y = 0
		pass
		
	func player_handle_input(player: Player) -> void:
		if Input.is_action_pressed("move_right"):
			player.playerState = player.Player_Run_Right_State
		if Input.is_action_pressed("move_left"):
			player.playerState = player.Player_Run_Left_State
		
class PlayerRunRightState extends PlayerStateMachine:
	func player_update(player: Player, delta: float) -> void:
		player.get_sprite().animation = "run"
		player.get_sprite().flip_h = false
		## player move right
		player.velocity.x = 1
		pass
		
	func player_handle_input(player: Player) -> void:
		if Input.is_action_pressed("move_left"):
			player.playerState = player.Player_Run_Left_State
		elif !Input.is_action_pressed("move_right") && !Input.is_action_pressed("move_down") && !Input.is_action_pressed("move_up"):
			player.playerState = player.Player_Idle_Right_State
			
class PlayerRunLeftState extends PlayerStateMachine:
	func player_update(player: Player, delta: float) -> void:
		player.get_sprite().animation = "run"
		player.get_sprite().flip_h = true
		
		## player move left
		player.velocity.x = -1
		pass
		
	func player_handle_input(player: Player) -> void:
		if Input.is_action_pressed("move_right"):
			player.playerState = player.Player_Run_Right_State
		elif !Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_down") && !Input.is_action_pressed("move_up"):
			player.playerState = player.Player_Idle_Left_State
