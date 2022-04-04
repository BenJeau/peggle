extends Control
class_name LevelUI

onready var level = get_parent().get_parent()

onready var game_over_overlay = $GameOverOverlay
onready var win_overlay = $WinOverlay
onready var menu_pause_overlay = $MenuPauseOverlay
onready var free_ball_overlay = $FreeBallOverlay

onready var score_label = $InfoContainer/ScoreLabel
onready var balls_left_label = $InfoContainer/BallsLeftLabel
onready var pegs_hit_label = $InfoContainer/PegsHitLabel
onready var time_elapsed_label = $InfoContainer/TimeElapsedLabel

func _process(_delta):
	if Input.is_action_just_pressed("menu_pause"):
		level.state = level.LEVEL_STATE.PAUSE

func update_score(score):
	score_label.text = str("Score: ", score)

func update_balls_left(num_balls):
	balls_left_label.text = str("Balls Left: ", num_balls)

func update_pegs_hit(num_pegs_hit):
	pegs_hit_label.text = str("Pegs Hit: ", num_pegs_hit)
	
func update_time_elapsed(time_elapsed):
	time_elapsed_label.text = str("Time Elapsed: ", time_elapsed)

func quit():
	get_tree().quit()

func hide_overlays():
	game_over_overlay.visible = false
	win_overlay.visible = false
	menu_pause_overlay.visible = false

func try_again():
	hide_overlays()
	level.restart()

func next_level():
	pass # Replace with function body.

func toggle_menu_pause():
	menu_pause_overlay.visible = not menu_pause_overlay.visible

func toggle_win():
	win_overlay.visible = not win_overlay.visible

func toggle_game_over():
	game_over_overlay.visible = not game_over_overlay.visible

func show_free_ball_overlay():
	free_ball_overlay.visible = true
	
	var time = 0.1
	var num_countdown = 9 + (randi() % 2)
	
	for i in range(num_countdown):
		yield(get_tree().create_timer(time * (i+1)), "timeout")
		$FreeBallOverlay/Node2D/CountdownLabel.text = str(i % 2)
	
	free_ball_overlay.visible = false
	level.state = level.LEVEL_STATE.PLAYING
	
	return num_countdown % 2
