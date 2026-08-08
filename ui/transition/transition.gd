class_name Transition
extends CanvasLayer

var background_tween: Tween

@onready var background: ColorRect = $Background
@onready var transition_text: Label = $Background/TransitionText

enum State {
	INACTIVE,
	FADING_IN,
	ACTIVE,
	FADING_OUT,
}

var state: State = State.INACTIVE


func play(text: String) -> void:
	await fade_in(text)
	await fade_out()


func fade_in(text: String) -> void:
	if state != State.INACTIVE:
		push_warning("Invalid state: %s" % State.keys()[state])
		return

	transition_text.text = text
	background.modulate.a = 0
	background.visible = true

	state = State.FADING_IN
	_init_background_tween()
	background_tween.tween_property(background, "modulate:a", 1, 0.5)
	await background_tween.finished
	state = State.ACTIVE
	await get_tree().create_timer(1.0).timeout


func fade_out() -> void:
	if state != State.ACTIVE:
		push_warning("Invalid state: %s" % State.keys()[state])
		return

	state = State.FADING_OUT
	_init_background_tween()
	background_tween.tween_property(background, "modulate:a", 0, 0.5)
	await background_tween.finished
	background.visible = false
	state = State.INACTIVE


func is_transitioning() -> bool:
	return state != State.INACTIVE


func _init_background_tween() -> void:
	background_tween = create_tween()
	background_tween.set_trans(Tween.TRANS_SINE)
	background_tween.set_ease(Tween.EASE_IN_OUT)
