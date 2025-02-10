extends Control

@onready var slides = [$SlideOne, $SlideTwo, $SlideThree]
var i: int = 0

func _on_button_pressed() -> void:
	if i < 2:
		slides[i].visible = false
		i += 1
		slides[i].visible = true
	else:
		Global.next_level()
