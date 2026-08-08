extends BaseDialogueTestScene

@onready var discussion: Discussion = $Discussion


func _ready() -> void:
	GameState.pseudo = "Protagoniste"
	var viewport_rect: Rect2 = get_viewport_rect()
	discussion.size = viewport_rect.size
	discussion.start(resource, title if not title.is_empty() else resource.first_title)
