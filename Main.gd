extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_hit() -> void:
	game_over()

func game_over():
	$ScoreTimer.stop()
	$PianoTimer.stop()
	$Hud.show_game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Hud.update_score(score)
	$Hud.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")

func _on_piano_timer_timeout() -> void:
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $PianoPath/PianoSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	$Hud.update_score(score)


func _on_start_timer_timeout() -> void:
	$PianoTimer.start()
	$ScoreTimer.start()
