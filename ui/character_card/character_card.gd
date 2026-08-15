@tool
class_name CharacterCard
extends Control

@export var character: Character
@export var variant: String

var character_tween: Tween
var reputation_tween: Tween

@onready var reputation_bar: ProgressBar = $VBoxContainer/MarginContainer/ReputationBar
@onready var character_tex_rect: TextureRect = $VBoxContainer/CharacterTexRect
@onready var gain_reputation_particles: GPUParticles2D = $GainReputationParticles
@onready var lose_reputation_particles: GPUParticles2D = $LoseReputationParticles


func _ready() -> void:
	_refresh_character()


func change_variant(new_variant: String) -> void:
	variant = new_variant
	_refresh_character()


func focus_character() -> void:
	_modulate_character(Color.WHITE, Vector2(1.05, 1.05))


func unfocus_character() -> void:
	_modulate_character(Color.WHITE.darkened(0.25), Vector2.ONE)


func update_reputation(points: int) -> void:
	var reputation: int = clampi(GameState.get_reputation(name) + points, 0, 100)
	GameState.reputations[name] = reputation

	var reputation_particles: GPUParticles2D
	if points > 0:
		reputation_particles = gain_reputation_particles
	else:
		reputation_particles = lose_reputation_particles

	reputation_particles.emitting = true

	if reputation_tween and reputation_tween.is_valid():
		reputation_tween.kill()
	reputation_tween = create_tween()
	reputation_tween.set_trans(Tween.TRANS_CUBIC)
	reputation_tween.set_ease(Tween.EASE_OUT)
	reputation_tween.tween_property(reputation_bar, "value", reputation, 0.4)
	await reputation_tween.finished

	reputation_particles.emitting = false


func _refresh_character() -> void:
	if character:
		reputation_bar.visible = character.is_love_interest
		if not Engine.is_editor_hint():
			reputation_bar.value = GameState.get_reputation(name)
		character_tex_rect.texture = character.get_variant_tex(variant)


func _modulate_character(color: Color, scale_vec: Vector2) -> void:
	if character_tween and character_tween.is_valid():
		character_tween.kill()
	character_tween = create_tween()
	character_tween.set_trans(Tween.TRANS_SINE)
	character_tween.set_ease(Tween.EASE_OUT)
	character_tween.set_parallel()
	character_tween.tween_property(character_tex_rect, "self_modulate", color, 0.15)
	character_tween.tween_property(character_tex_rect, "offset_transform_scale", scale_vec, 0.1)
