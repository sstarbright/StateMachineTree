class_name StateMethodList
extends Resource
## A list of Method Callbacks that are typically invoked by a StateTree during certain states.

@export var callbacks : Array[StateMethodCallback]

func invoke():
	for callback in callbacks:
		callback.invoke()
