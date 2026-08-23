class_name Transition
extends CanvasLayer

enum State {
	INACTIVE,
	FADING_IN,
	ACTIVE,
	FADING_OUT,
}

var background_tween: Tween

var state: State = State.INACTIVE

@onready var background: ColorRect = %Background
@onready var transition_text: Label = %TransitionText
@onready var perfect_particles: GPUParticles2D = %PerfectParticles


func _ready() -> void:
	background.modulate.a = 0
	background.visible = false


func play(text: String, wait: float, perfect_effect: bool) -> void:
	await fade_in_and_wait(text, wait, perfect_effect)
	await fade_out()


func fade_in_and_wait(text: String, wait: float, perfect_effect: bool) -> void:
	if state != State.INACTIVE:
		push_warning("Invalid state: %s" % State.keys()[state])
		return

	transition_text.text = text.replace("\\n", "\n")
	background.modulate.a = 0
	background.visible = true
	perfect_particles.emitting = true

	state = State.FADING_IN
	_init_background_tween()
	background_tween.tween_property(background, "modulate:a", 1, 0.5)
	await background_tween.finished
	state = State.ACTIVE
	await get_tree().create_timer(wait).timeout
	perfect_particles.emitting = false


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
	background_tween = TweenUtils.setup_tween(self, background_tween, Tween.TRANS_SINE)
