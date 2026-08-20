class_name TweenUtils
extends Object


static func setup_tween(
	node: Node,
	tween: Tween,
	transition_type: Tween.TransitionType = Tween.TRANS_LINEAR,
	ease_type: Tween.EaseType = Tween.EASE_IN_OUT,
) -> Tween:
	if tween and tween.is_valid():
		tween.kill()
	tween = node.create_tween()
	tween.set_trans(transition_type)
	tween.set_ease(ease_type)
	return tween
