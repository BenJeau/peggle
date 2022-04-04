extends Node2D
class_name Level1

var score = 0
var num_pegs_hit = 0
var total_pegs_hit = 0
onready var total_num_pegs = $Pegs.get_children().size()
var balls_left = 10
var time_elapsed = 0

var ball_visible = false

enum LEVEL_STATE { PLAYING, PAUSE, GAME_OVER, WIN, FREE_BALL }

var state = LEVEL_STATE.PLAYING setget state_change

onready var level_ui = $LevelUIContainer/LevelUI

func _ready():
	randomize()


func state_change(new_state):
	state = new_state
	
	if new_state != LEVEL_STATE.PLAYING:
		$BallShooter.follow_mouse = $BallShooter.BALL_BUCKET_ROTATION_SOURCE.NONE
		$LevelUIContainer.z_index = 1
	else:
		$BallShooter.follow_mouse = $BallShooter.BALL_BUCKET_ROTATION_SOURCE.MOUSE
		$LevelUIContainer.z_index = 0
	
	match new_state:
		LEVEL_STATE.WIN:
			level_ui.toggle_win()
		LEVEL_STATE.GAME_OVER:
			level_ui.toggle_game_over()
		LEVEL_STATE.PAUSE:
			level_ui.toggle_menu_pause()
		LEVEL_STATE.FREE_BALL:
			self.balls_left += yield(level_ui.show_free_ball_overlay(), "completed")

func _process(delta):
	if self.state != LEVEL_STATE.PLAYING:
		return
	
	$BallBucketPath/BallBucketPosition.offset += delta * $BallBucketPath.curve.get_baked_length() * 0.5
	$BallBucket.position = $BallBucketPath/BallBucketPosition.position
		
	self.time_elapsed += delta
	
	level_ui.update_score(self.score)
	level_ui.update_balls_left(self.balls_left)
	level_ui.update_pegs_hit(self.num_pegs_hit)
	level_ui.update_time_elapsed(self.time_elapsed)

	if Input.is_action_just_pressed("shoot_ball") and self.balls_left > 0 and not self.ball_visible:
		var new_ball = $BallShooter.create_ball()
		add_child(new_ball)
		self.balls_left -= 1
		self.ball_visible = true
		
		new_ball.get_node("VisibilityNotifier2D").connect("screen_exited", self, "ball_exited_screen")

func ball_exited_screen():
	self.ball_visible = false
	self.score += num_pegs_hit * 10
	
	self.total_pegs_hit += num_pegs_hit
	
	if self.num_pegs_hit == 0:
		self.state = LEVEL_STATE.FREE_BALL
	elif self.total_pegs_hit == self.total_num_pegs:
		self.state = LEVEL_STATE.WIN
	elif balls_left == 0:
		self.state = LEVEL_STATE.GAME_OVER
	
	self.num_pegs_hit = 0

func peg_hit():
	self.num_pegs_hit += 1

func restart():
	self.score = 0
	self.balls_left = 10
	self.time_elapsed = 0
	self.total_pegs_hit = 0
	
	self.state = LEVEL_STATE.PLAYING
	
	for peg in $Pegs.get_children():
		peg.reset()
