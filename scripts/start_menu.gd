extends Node2D


func _on_start_button_pressed() -> void:
	Global.next_level()


func _on_quit_button_pressed() -> void:
	get_tree().quit(0)


func _on_how_to_play_pressed() -> void:
	$HowToPlay.visible = true


func _on_menu_button_pressed() -> void:
	$HowToPlay.visible = false
