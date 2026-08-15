@tool
extends BaseDialogueTestScene

@onready var discussion: Discussion = $Discussion


func _ready() -> void:
	var viewport_rect: Rect2 = get_viewport_rect()
	discussion.size = viewport_rect.size
	if not Engine.is_editor_hint():
		GameState.pseudo = "Protagoniste"
		discussion.start(resource, title if not title.is_empty() else resource.first_title)
