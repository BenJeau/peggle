extends Node2D
class_name BallBasket

export (PackedScene) var Ball

enum BALL_BUCKET_ROTATION_SOURCE {
	MOUSE,
	KEYS,
	NONE
}

var keys_rotation_step = 0.01
var follow_mouse = BALL_BUCKET_ROTATION_SOURCE.MOUSE
var last_mouse_position = Vector2()

func _process(_delta):
	if follow_mouse == BALL_BUCKET_ROTATION_SOURCE.NONE:
		return
	
	if Input.is_action_pressed("ball_shooter_move_left"):
		follow_mouse = BALL_BUCKET_ROTATION_SOURCE.KEYS
		update_rotation(rotation + keys_rotation_step)
	
	if Input.is_action_pressed("ball_shooter_move_right"):
		follow_mouse = BALL_BUCKET_ROTATION_SOURCE.KEYS
		update_rotation(rotation - keys_rotation_step)
	
	var mouse_position = get_viewport().get_mouse_position()
	if last_mouse_position != mouse_position and follow_mouse == BALL_BUCKET_ROTATION_SOURCE.KEYS:
		follow_mouse = BALL_BUCKET_ROTATION_SOURCE.MOUSE
	
	if follow_mouse == BALL_BUCKET_ROTATION_SOURCE.MOUSE:
		var ball_shooter_position = get_global_transform().origin

		update_rotation(ball_shooter_position.angle_to_point(mouse_position) + PI/2)
		last_mouse_position = mouse_position

func update_rotation(radians):
	rotation = clamp(radians, -1.34, 1.34)

func create_ball():
	var new_ball: RigidBody2D = Ball.instance()
	
	new_ball.position = $Shooter.global_position
	new_ball.rotation = rotation
	new_ball.apply_impulse(Vector2(), Vector2(0, 800).rotated(rotation))
	
	return new_ball
