extends OpponentBehaviour

### "Classy" approach:
# The idea is we have three subbehaviours, first we turn towards the player,
# then we put a block, then if we got hit while blocking, we block_react.
# We have three core methods: formulate input, react_on_hit and is_open_to_reconsiderations
# dependend on the phase (state) of our behaviour.
# So we either spam if statements to route calls dependent on phase, or we delegate.
# I created thee small internal classes to define those behaviours,
# then in original calls I just delegate the logic.
# This approach seems to be a complete overkill for a behaviour with consistent
# three-step plan, but I think it's important to document it, because we can have much
# broader behaviours in theory, and one day if-spam just won't cut it. 

# TODO test and benchmark to decide between instantiation and having in memory
class BlockSubbehaviour :
	var block_behaviour : OpponentBehaviour
	
	func formulate_input(delta : float):
		return OpponentActionInput.blank()
	
	func react_on_hit(hit: HitData):
		block_behaviour.base_react_on_hit(hit)
	
	func is_open_to_reconsiderations() -> bool:
		return false
	
	func update_resources(delta):
		block_behaviour.resources.update_without_stamina(delta)

# we formulate input, but don't transition and has a default hit reaction
class TurnToPlayer extends BlockSubbehaviour:
	
	func _init(parent_behaviour : OpponentBehaviour):
		block_behaviour = parent_behaviour
	
	func formulate_input(delta : float):
		var next_input = OpponentActionInput.new()
		next_input.direction_input = block_behaviour.beliefs.character_direction_to_player()
		return next_input
	
	func update_resources(delta):
		block_behaviour.resources.update(delta)

# we have block reaction and we have transition condition, but we don't provide input
class Blocking extends BlockSubbehaviour:
	
	var blocking_await_time : float = 0.8
	var enter_block_time : float
	var block_coefficient : float
	
	func _init(parent_behaviour : OpponentBehaviour, blocking_coefficient):
		enter_block_time = Time.get_unix_time_from_system()
		block_behaviour = parent_behaviour
	
	func react_on_hit(hit: HitData):
		if block_behaviour.position_in_blocking_sector(hit.weapon.holder.global_position):
			block_behaviour.resources.pay_block_cost(hit.damage, block_coefficient)
			block_behaviour.switch_to_block_reaction()
		else:
			super.react_on_hit(hit)
	
	func is_open_to_reconsiderations() -> bool:
		return Time.get_unix_time_from_system() - enter_block_time > blocking_await_time

# we have block reaction and we have transition condition, but we don't provide input
class BlockReaction extends  BlockSubbehaviour:
	
	var block_coefficient : float
	
	func _init(parent_behaviour : OpponentBehaviour, blocking_coefficient):
		block_behaviour = parent_behaviour
	
	func react_on_hit(hit: HitData):
		if block_behaviour.position_in_blocking_sector(hit.weapon.holder.global_position):
			block_behaviour.resources.pay_block_cost(hit.damage, block_coefficient)
		else:
			super.react_on_hit(hit)
	
	func is_open_to_reconsiderations() -> bool:
		return block_behaviour.current_action.works_longer_than(block_behaviour.current_action.duration)

@export var block_sector : float = 1.5

var current_phase : BlockSubbehaviour

func choose_action():
	if current_phase is TurnToPlayer and player_in_blocking_sector():
		current_phase = Blocking.new(self, actions_container.get_action("block").block_coefficient)
		switch_to("block")

func on_enter_behaviour():
	current_phase = TurnToPlayer.new(self)

func select_initial_action():
	enter_action("run")

func player_in_blocking_sector() -> bool:
	return character.basis.z.angle_to(beliefs.character_direction_to_player()) < block_sector / 2

func position_in_blocking_sector(position : Vector3) -> bool:
	return character.basis.z.angle_to(beliefs.character_direction_to(position)) < block_sector / 2

func base_react_on_hit(hit : HitData):
	super.react_on_hit(hit)

func switch_to_block_reaction():
	current_phase = BlockReaction.new(self, actions_container.get_action("block").block_coefficient)
	switch_to("block_reaction")

func react_on_hit(hit : HitData):
	current_phase.react_on_hit(hit)

func is_open_to_reconsiderations() -> bool:
	return current_phase.is_open_to_reconsiderations()

func update_resources(delta : float):
	current_phase.update_resources(delta)

func formulate_input(delta : float) -> OpponentActionInput:
	return current_phase.formulate_input(delta)


### CLASSLESS APPROACH:

#@export var block_sector : float = 1.5
#
#enum Phases {TURN, BLOCK, REACTING} # poor man's states
#var current_phase : Phases
#
#func update(input : OpponentActionInput, delta ):
	#current_action.update(input, delta)
#
## So how it works is we start in run action and TURN mode. 
## We rotate towards the player until we have them in a blocking sector.
## Then we switch our action and mode to block and chill without emitting inputs.
## If we were hit during the block we switch to block reaction
## we exit the behaviour after a successful block on block reaction expiring,
## or after some no_hits_delay - the variant where we put up a block but no hits
## were coming after some time.
#func choose_action():
	#if current_phase == Phases.TURN and player_in_blocking_sector():
		#current_phase = Phases.BLOCK
		#switch_to("block")
#
#
#func formulate_input(_delta : float) -> OpponentActionInput:
	#if current_phase == Phases.TURN:
		#var next_input = OpponentActionInput.new()
		#next_input.direction_input = beliefs.character_direction_to_player()
		#return next_input
	#return null
#
#func is_open_to_reconsiderations():
	#if current_phase == Phases.TURN:
		#return false
	#if current_phase == Phases.BLOCK and waiting_too_long():
		#forced_to_reconsider = true
		#return true
	#if current_phase == Phases.BLOCK_REACTION and current_action.works_longer_than(current_action.duration):
		#forced_to_reconsider = true
		#return true
	#return false
#
#func on_enter_behaviour():
	#current_phase = Phases.TURN
#
#func on_exit_behaviour():
	#pass
#
#
#func select_initial_action():
	#enter_action("run")
#
#
#func react_on_hit(hit : HitData):
	#if position_in_blocking_sector(hit.weapon.holder.global_position) and beliefs.character_is_blocking():
		#if current_phase == Phases.BLOCK:
			#current_phase = Phases.REACTING
			#switch_to("block_reaction")
		#resources.pay_block_cost(hit.damage, actions_container.get_action("block").block_coefficient)
	#else:
		#super.react_on_hit(hit)
#
#func player_in_blocking_sector() -> bool:
	#return character.basis.z.angle_to(beliefs.character_direction_to_player()) < block_sector / 2
#
#func position_in_blocking_sector(position : Vector3) -> bool:
	#return character.basis.z.angle_to(beliefs.character_direction_to(position)) < block_sector / 2
