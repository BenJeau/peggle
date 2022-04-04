extends RigidBody2D
class_name Ball

func _on_Ball_body_entered(body):
	if body is Peg:
		yield(get_tree().create_timer(0.01), "timeout")
		body.clear()
		get_parent().peg_hit()

	if body is BallBucket:
		get_parent().balls_left += 1
		queue_free()
