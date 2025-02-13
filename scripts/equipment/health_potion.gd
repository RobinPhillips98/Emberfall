extends StaticBody2D

func _on_area_2d_body_entered(body):
	if body.has_method("gain_potion"):
		body.gain_potion("health_potion")
		await get_tree().create_timer(0.1).timeout
		queue_free()
