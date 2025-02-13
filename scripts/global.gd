extends Node2D

var level_count: int = 1

func game_over():
	get_node("/root/Game/GameOver").visible = true
	get_tree().paused = true
	await get_tree().create_timer(5).timeout
	get_tree().quit(0)

func next_level():
	match level_count:
		1:
			get_tree().change_scene_to_file("res://scenes/user-interface/intro.tscn")
		2:
			get_tree().change_scene_to_file("res://scenes/levels/level_one.tscn")
		3:
			get_tree().change_scene_to_file("res://scenes/levels/level_two.tscn")
		4:
			get_tree().change_scene_to_file("res://scenes/levels/level_three.tscn")
		5:
			get_tree().change_scene_to_file("res://scenes/user-interface/end_scene.tscn")
	level_count += 1
