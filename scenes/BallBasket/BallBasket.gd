extends Node2D
class_name BallBasket

export (PackedScene) var Ball

var follow_mouse = true

func _process(delta):
	if follow_mouse:
		var mouse_position = get_viewport().get_mouse_position()
		var ball_shooter_position = get_global_transform().origin

		rotation = ball_shooter_position.angle_to_point(mouse_position) + PI/2

func create_ball():
	var new_ball: RigidBody2D = Ball.instance()
	
	new_ball.position = $Shooter.global_position
	new_ball.rotation = rotation
	new_ball.apply_impulse(Vector2(), Vector2(0, 800).rotated(rotation))
	
	return new_ball
