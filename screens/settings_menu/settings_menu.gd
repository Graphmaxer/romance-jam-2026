class_name SettingsMenu
extends CanvasLayer

var transition_tween: Tween

@onready var settings_container: MarginContainer = %SettingsContainer


func _ready() -> void:
	settings_container.modulate.a = 0
	visible = false


func open() -> void:
	visible = true
	transition_tween = TweenUtils.setup_tween(self, transition_tween)
	transition_tween.tween_property(settings_container, "modulate:a", 1, 0.5)


func close() -> void:
	transition_tween = TweenUtils.setup_tween(self, transition_tween)
	transition_tween.tween_property(settings_container, "modulate:a", 0, 0.5)
	await transition_tween.finished
	visible = false


func _set_volume(bus_name: String, volume: float) -> void:
	var bus_idx: int = AudioServer.get_bus_index(bus_name)
	if bus_idx != -1:
		AudioServer.set_bus_volume_linear(bus_idx, volume)


func _on_global_slider_value_changed(value: float) -> void:
	_set_volume("Master", value)


func _on_music_slider_value_changed(value: float) -> void:
	_set_volume("Music", value)


func _on_effects_slider_value_changed(value: float) -> void:
	_set_volume("Effects", value)


func _on_close_button_pressed() -> void:
	close()
