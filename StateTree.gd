@tool
class_name StateTree
extends AnimationTree
## A State Machine that uses Godot's AnimationNodeStateMachine to allow for easy State Machine creation.

var current_state = ""
var state_player : AnimationPlayer
var empty_update = StateMethodList.new()
@onready var current_update = empty_update

# Callbacks invoked when the specified State is entered.
@export var entry_callbacks : Dictionary[String, StateCallbackList]
# Callbacks invoked when the StateTree is updated every physics frame while the specified State is current.
@export var update_callbacks : Dictionary[String, StateMethodList]
# Callbacks invoked when the specified State is exited.
@export var exit_callbacks : Dictionary[String, StateCallbackList]

func _enter_tree() -> void:
	if Engine.is_editor_hint() && get_child_count() < 1:
		var new_player = AnimationPlayer.new() as AnimationPlayer
		var new_library = AnimationLibrary.new() as AnimationLibrary
		var new_animation = Animation.new() as Animation
		new_animation.length = 1.0
		new_library.add_animation("State", new_animation)
		new_player.add_animation_library("", new_library)
		add_child(new_player)
		new_player.name = "StatePlayer"
		new_player.owner = get_tree().edited_scene_root
		anim_player = get_path_to(new_player)
		tree_root = AnimationNodeStateMachine.new()

func _ready():
	if !Engine.is_editor_hint():
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
					var animation_to_copy = tree_root.get_node(state_node) as AnimationNode
					if animation_to_copy is AnimationNodeAnimation:
						target_library.add_animation(state_node, target_library.get_animation(animation_to_copy.animation))
						animation_to_copy.animation = state_node
			animation_started.connect(state_change)

# Called internally on State change.
func state_change(state_name : String):
	if !Engine.is_editor_hint():
		# Calls an exit function for the current state, if there is one
		if current_state.length() > 0 && exit_callbacks.has(current_state):
			exit_callbacks[current_state].invoke()
		
		# Calls an enter function for the current state, if there is one
		current_state = state_name
		if entry_callbacks.has(current_state):
			entry_callbacks[current_state].invoke()
		if update_callbacks.has(current_state):
			current_update = update_callbacks[current_state]
		else:
			current_update = empty_update

func _physics_process(delta: float) -> void:
	if !Engine.is_editor_hint():
		# Calls an update callbacks for the current state
		current_update.invoke(delta)
