extends StaticBody2D
class_name Peg

func clear():
	visible = false
	$CollisionShape2D.disabled = true

func reset():
	visible = true
	$CollisionShape2D.disabled = false
