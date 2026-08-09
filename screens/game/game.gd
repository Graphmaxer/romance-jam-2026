extends Control

const LOVE_INTEREST_SELECTION: PackedScene = preload(
	"res://screens/love_interest_selection/love_interest_selection.tscn"
)
const PROLOGUE: DialogueResource = preload("res://dialogues/prologue.dialogue")

@export var routes: Array[Route]

var love_interest_selection_tween: Tween

@onready var discussion: Discussion = $Discussion


func _ready() -> void:
	_start_discussion()


func _start_discussion() -> void:
	var dialogue: DialogueResource = PROLOGUE
	if GameState.love_interest and GameState.chapter_number:
		for route: Route in routes:
			if route.character.firstname == GameState.love_interest:
				dialogue = route.chapters[GameState.chapter_number - 1]
	discussion.start(dialogue, dialogue.first_title)


func _init_love_interest_selection_tween() -> void:
	if love_interest_selection_tween and love_interest_selection_tween.is_valid():
		love_interest_selection_tween.kill()
	love_interest_selection_tween = create_tween()
	love_interest_selection_tween.set_trans(Tween.TRANS_SINE)
	love_interest_selection_tween.set_ease(Tween.EASE_IN_OUT)


func _on_discussion_ended(dialogue: DialogueResource) -> void:
	if dialogue == PROLOGUE:
		var love_interest_selection: Control = LOVE_INTEREST_SELECTION.instantiate()
		love_interest_selection.modulate.a = 0
		love_interest_selection.connect("chosen", _on_love_interest_selection_chosen)
		add_child(love_interest_selection)

		_init_love_interest_selection_tween()
		love_interest_selection_tween.tween_property(love_interest_selection, "modulate:a", 1, 1.0)


func _on_love_interest_selection_chosen(firstname: String) -> void:
	GameState.love_interest = firstname
	GameState.chapter_number = 1

	var love_interest_selection: Node = get_node_or_null("LoveInterestSelection")
	if love_interest_selection:
		_init_love_interest_selection_tween()
		love_interest_selection_tween.tween_property(love_interest_selection, "modulate:a", 0, 1.0)
		await love_interest_selection_tween.finished
		remove_child(love_interest_selection)
		love_interest_selection.queue_free()
	_start_discussion()
