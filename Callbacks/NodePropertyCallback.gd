class_name NodePropertyCallback
extends StatePropertyCallback

@export var target_node : NodePath

var loaded_node : Node

func setup(parent_node : Node):
	loaded_node = parent_node.get_node(target_node)

func invoke(_args : Array):
	loaded_node.set(property_name, property_value)
