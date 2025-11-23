class_name StateCallbackList
extends Resource
## A list of Callbacks that are typically invoked by a StateTree during certain states.

@export var callbacks : Array[StateCallback]

func setup(parent_node : Node):
	for callback in callbacks:
		callback.setup(parent_node)

func invoke():
	for callback in callbacks:
		callback.invoke()
