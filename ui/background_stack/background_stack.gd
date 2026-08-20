class_name BackgroundStack
extends Control

var background_tween: Tween

@onready var background: TextureRect = %Background
@onready var next_background: TextureRect = %NextBackground


func update_background(new_background: Texture2D, skip_transition: bool = false) -> void:
	if not background.texture or skip_transition:
		background.texture = new_background
		return

	background.self_modulate.a = 1
	next_background.self_modulate.a = 0
	next_background.texture = new_background

	background_tween = TweenUtils.setup_tween(self, background_tween, Tween.TRANS_SINE)
	background_tween.tween_property(next_background, "self_modulate:a", 1, 1.0)
	await background_tween.finished

	background.texture = new_background
	next_background.self_modulate.a = 0
