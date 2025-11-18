class_name ResourceMethodCallback
extends StateMethodCallback

@export var target_resource : Resource

func invoke():
	target_resource.callv(method_name, method_arguments)
