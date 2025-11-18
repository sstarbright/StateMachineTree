class_name StateCallbackList
extends Resource

@export var callbacks : Array[StateCallback]

func setup(parent_node : Node):
	for callback in callbacks:
		callback.setup(parent_node)

func invoke():
	for callback in callbacks:
		callback.invoke()
