extends Node

export (PackedScene) var Mob
var score

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$HUD.show_game_over()
	$DeathSound.play()

func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get ready!")
	$Player.start($StartPosition.position)
	$Music.play()
	$StartTimer.start()


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_MobTimer_timeout():
	var mob = Mob.instance()
	add_child(mob)
	
	$MobPath/MobSpawnLocation.offset = randi()
	mob.position = $MobPath/MobSpawnLocation.position
	
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	mob.linear_velocity = Vector2(
		rand_range(mob.min_speed, mob.max_speed), 0
		).rotated(direction)
	
	$HUD.connect("start_game", mob, "_on_start_game")
