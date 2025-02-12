extends Area2D

@onready var player = get_node("/root/Game/Player")

func _ready():
	pass

func _physics_process(delta):
	look_at(player.global_position)

func shoot():
	const ARROW = preload("res://scenes/enemies/skeleton-arrow.tscn")
	var new_arrow = ARROW.instantiate()
	new_arrow.global_position = %ShootingPoint.global_position
	new_arrow.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_arrow)
