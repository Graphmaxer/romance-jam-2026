@tool
class_name Character
extends Resource

@export var firstname: String
@export var aliases: Array[String]
@export var age: int
@export var birthday: String
@export_multiline var description: String
@export var variants: Dictionary[String, Texture2D]
@export var is_love_interest: bool = false


func get_variant_tex(variant: String = "default") -> Texture2D:
	if variants.has(variant):
		return variants[variant]
	return null
