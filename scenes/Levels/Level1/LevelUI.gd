extends Control
class_name LevelUI

func update_score(score):
	$InfoContainer/ScoreLabel.text = str("Score: ", score)

func update_balls_left(num_balls):
	$InfoContainer/BallsLeftLabel.text = str("Balls Left: ", num_balls)

func update_pegs_hit(num_pegs_hit):
	$InfoContainer/PegsHitLabel.text = str("Pegs Hit: ", num_pegs_hit)
	
func update_time_elapsed(time_elapsed):
	$InfoContainer/TimeElapsedLabel.text = str("Time Elapsed: ", time_elapsed)

func quit():
	get_tree().quit()

func try_again():
	$GameOverOverlay.visible = false
	$WinOverlay.visible = false
	get_parent().get_parent().restart()

func next_level():
	pass # Replace with function body.
