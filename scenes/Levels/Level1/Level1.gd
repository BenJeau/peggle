extends Node2D
class_name Level1

var score = 0
var num_pegs_hit = 0
var total_pegs_hit = 0
onready var total_num_pegs = $Pegs.get_children().size()
var balls_left = 10
var time_elapsed = 0

var ball_visible = false

enum LEVEL_STATE { PLAYING, PAUSE, GAME_OVER, WIN }

var state = LEVEL_STATE.PLAYING

func _process(delta):
	if state != LEVEL_STATE.PLAYING:
		return
		
	time_elapsed += delta
	
	$LevelUIContainer/LevelUI.update_score(score)
	$LevelUIContainer/LevelUI.update_balls_left(balls_left)
	$LevelUIContainer/LevelUI.update_pegs_hit(num_pegs_hit)
	$LevelUIContainer/LevelUI.update_time_elapsed(time_elapsed)

	if Input.is_action_just_pressed("shoot_ball") and balls_left > 0 and not ball_visible:
		var new_ball = $BallShooter.create_ball()
		add_child(new_ball)
		balls_left -= 1
		ball_visible = true
		
		new_ball.get_node("VisibilityNotifier2D").connect("screen_exited", self, "ball_exited_screen")

func ball_exited_screen():
	ball_visible = false
	score += num_pegs_hit * 10
	
	total_pegs_hit += num_pegs_hit
	num_pegs_hit = 0
	
	if total_pegs_hit == total_num_pegs:
		state = LEVEL_STATE.WIN
		$LevelUIContainer/LevelUI/WinOverlay.visible = true
		$BallShooter.follow_mouse = false
		$LevelUIContainer.z_index = 1
	elif balls_left == 0:
		state = LEVEL_STATE.GAME_OVER
		$LevelUIContainer/LevelUI/GameOverOverlay.visible = true
		$BallShooter.follow_mouse = false
		$LevelUIContainer.z_index = 1
	
func peg_hit():
	num_pegs_hit += 1

func restart():
	score = 0
	balls_left = 10
	time_elapsed = 0
	total_pegs_hit = 0
	
	$BallShooter.follow_mouse = true
	$LevelUIContainer.z_index = 0
	state = LEVEL_STATE.PLAYING
	
	for peg in $Pegs.get_children():
		peg.reset()
