@tool
class_name Character extends Resource

@export var firstname: String
@export var neutral_face: Texture2D
@export var angry_face: Texture2D

enum Face { NEUTRAL, ANGRY }

var face: Face = Face.NEUTRAL
var reputation: int = 0

func get_face_tex() -> Texture2D:
	match self.face:
		Character.Face.NEUTRAL:
			return self.neutral_face
		Character.Face.ANGRY:
			return self.angry_face
		_:
			return self.neutral_face
