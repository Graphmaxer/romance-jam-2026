extends CanvasLayer

@onready var background: ColorRect = $Background
@onready var transition_text: Label = $Background/TransitionText

var background_tween: Tween


func start_transition(text: String) -> void:
	if background_tween and background_tween.is_valid():
		push_warning("Transition already in progress")
		return

	transition_text.text = text

	background.modulate.a = 0
	background.visible = true

	background_tween = create_tween()
	background_tween.tween_property(background, "modulate:a", 1, 0.5)
	background_tween.tween_interval(1.0)
	background_tween.tween_property(background, "modulate:a", 0, 0.5)

	await background_tween.finished

	background.visible = false
