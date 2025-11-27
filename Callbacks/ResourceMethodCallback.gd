class_name ResourceMethodCallback
extends StateMethodCallback

@export var target_resource : Resource

func invoke(args : Array):
	args.append_array(method_arguments)
	target_resource.callv(method_name, args)
