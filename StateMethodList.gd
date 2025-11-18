class_name StateMethodList
extends Resource

@export var callbacks : Array[StateMethodCallback]

func invoke():
	for callback in callbacks:
		callback.invoke()
