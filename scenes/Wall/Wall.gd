extends StaticBody2D

export var color = Color(255, 255, 255)

func _process(_delta):
	$ColorRect.color = color
