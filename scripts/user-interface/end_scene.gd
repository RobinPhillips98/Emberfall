extends Control

func _ready():
	$YouWin/Score.text = "TOTAL XP = " + str(PlayerVariables.xp)
	await get_tree().create_timer(4).timeout
	$BackgroundMusic.play()



func _on_art_credits_button_pressed() -> void:
	%YouWin.visible = false
	%ArtCredits.visible = true


func _on_back_pressed() -> void:
	%YouWin.visible = true
	%ArtCredits.visible = false


func _on_quit_pressed() -> void:
	get_tree().quit(0)
