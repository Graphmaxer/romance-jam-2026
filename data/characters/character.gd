@tool
class_name Character
extends Resource

enum Face {
	NEUTRAL,
	ANGRY,
}

@export var firstname: String
@export var age: int
@export var birthday: String
@export_multiline var description: String
@export var neutral_face: Texture2D
@export var angry_face: Texture2D
@export var is_love_interest: bool = false

var face: Face = Face.NEUTRAL


func get_face_tex() -> Texture2D:
	match self.face:
		Face.NEUTRAL:
			return self.neutral_face
		Face.ANGRY:
			return self.angry_face
		_:
			return self.neutral_face
