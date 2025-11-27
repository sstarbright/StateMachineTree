class_name ResourcePropertyCallback
extends StatePropertyCallback

@export var target_resource : Resource

func invoke(_args : Array):
	target_resource.set(property_name, property_value)
