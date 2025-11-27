class_name NodeMethodCallback
extends StateMethodCallback

@export var target_node : NodePath

var loaded_node : Node

func setup(parent_node : Node):
	loaded_node = parent_node.get_node(target_node)

func invoke(args : Array):
	args.append_array(method_arguments)
	loaded_node.callv(method_name, args)
