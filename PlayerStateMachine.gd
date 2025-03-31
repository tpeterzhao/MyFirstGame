class_name PlayerStateMachine
extends StateMachine

func enter_state(player: Player) -> void:
	pass
	
func player_update(player: Player, delta: float) -> void:
	super.update(player, delta)
	pass
	
func player_handle_input(player: Player) -> void:
	
	pass
	
func player_handle_events(player: Player) -> void:
	## go to hurt state if hurt
	
	## go to death state if health is 0
	
	## go to attack state if attacck timer is up
	
	pass
