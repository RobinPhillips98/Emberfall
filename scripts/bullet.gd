extends Area2D

var travelled_distance = 0
@onready var player = get_node("/root/Game/Player")
@onready var bow = player.bow

func _physics_process(delta):
	const SPEED = 1000
	var RANGE = bow.range
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta

	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()


func _on_body_entered(body):
	queue_free()
	
	if body.has_method("take_damage"):
			body.take_damage(bow.damage)
