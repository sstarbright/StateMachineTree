@tool
class_name AnimationStateTree
extends AnimationTree
## An Animation State Machine based on the behaviour of the StateTree node.

var current_state := ""
var state_player : AnimationPlayer
var empty_update = StateMethodList.new()
var state_machine : AnimationNodeStateMachinePlayback
@onready var current_update = empty_update

# Callbacks invoked when the specified State is entered.
@export var entry_callbacks : Dictionary[String, StateCallbackList]
# Callbacks invoked when the StateTree is updated every physics frame while the specified State is current.
@export var update_callbacks : Dictionary[String, StateMethodList]
# Callbacks invoked when the specified State is exited.
@export var exit_callbacks : Dictionary[String, StateCallbackList]

func _enter_tree() -> void:
	if Engine.is_editor_hint() && tree_root == null:
		tree_root = AnimationNodeStateMachine.new()

func _ready():
	if !Engine.is_editor_hint():
		state_machine = get("parameters/playback")
		state_player = get_node_or_null(anim_player) as AnimationPlayer
		
		if state_player:
			for callback_list in entry_callbacks:
				entry_callbacks[callback_list].setup(self)
			for callback_list in update_callbacks:
				update_callbacks[callback_list].setup(self)
			for callback_list in exit_callbacks:
				exit_callbacks[callback_list].setup(self)
			var target_library = state_player.get_animation_library("")
		
			var node_list = tree_root.get_node_list()
			for state_node in node_list:
				if state_node != "Start" && state_node != "End":
					var animation_to_copy = tree_root.get_node(state_node)
					if animation_to_copy is AnimationNodeAnimation:
						var state_split = animation_to_copy.animation.split("/") as PackedStringArray
						var old_library = state_player.get_animation_library(state_split[0])
						target_library.add_animation(state_node, old_library.get_animation(state_split[state_split.size()-1]))
						animation_to_copy.animation = state_node

# Overriddable function called on State change.
func state_change(old_state : String, new_state : String):
	pass

# Called internally on State change.
func change_state(state_name : String):
	# Calls an exit function for the current state, if there is one
	if current_state.length() > 0 && exit_callbacks.has(current_state):
		exit_callbacks[current_state].invoke()
	
	var old_state = current_state
	current_state = state_name
	state_change(old_state, current_state)
	
	# Calls an enter function for the current state, if there is one
	if entry_callbacks.has(current_state):
		entry_callbacks[current_state].invoke()
	if update_callbacks.has(current_state):
		current_update = update_callbacks[current_state]
	else:
		current_update = empty_update

func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
		var new_current_state := state_machine.get_current_node()
		if current_state != new_current_state:
			change_state(new_current_state)
		else:
			# Calls an update callbacks for the current state
			current_update.invoke(delta)
