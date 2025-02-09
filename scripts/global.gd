extends Node2D

var level_count: int = 1

func game_over():
	get_node("/root/Game/GameOver").visible = true
	get_tree().paused = true

func next_level():
	match level_count:
		1:
			get_tree().change_scene_to_file("res://scenes/test-levels/test_level_one.tscn")
		2:
			get_tree().change_scene_to_file("res://scenes/test-levels/test_level_two.tscn")
		3:
			get_tree().change_scene_to_file("res://scenes/test-levels/test_level_three.tscn")
		4:
			get_tree().change_scene_to_file("res://scenes/end_scene.tscn")
	level_count += 1
