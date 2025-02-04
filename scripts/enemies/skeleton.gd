extends CharacterBody2D

const BASE_SPEED = 300
const AGGRO_RANGE = 500
const EVADE_RANGE = 250
const ATTACK_RANGE = EVADE_RANGE + 100
var health = 30
@onready var speed = BASE_SPEED
@onready var player = get_node("/root/Game/Player")
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var direction = global_position.direction_to(player.global_position)
	
func _process(delta):
	animation_tree.set("parameters/conditions/idle", velocity == Vector2.ZERO)
	animation_tree.set("parameters/conditions/is_moving", velocity != Vector2.ZERO)
	
	if global_position.distance_to(player.global_position) < ATTACK_RANGE and randf() < 0.25 * delta:
		attack()

func _physics_process(delta):
	if global_position.distance_to(player.global_position) < EVADE_RANGE:
		direction = -global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
	elif global_position.distance_to(player.global_position) < AGGRO_RANGE and global_position.distance_to(player.global_position) > ATTACK_RANGE:
		direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
	else:
		direction = global_position.direction_to(player.global_position)
		velocity = Vector2.ZERO
		
	if direction.x > 0:
		$Sprite2D.flip_h = false
	elif direction.x < 0:
		$Sprite2D.flip_h = true

	#if global_position.distance_to(player.global_position) < ATTACK_RANGE and randf() < 0.5 * delta:
		

func take_damage(value):
	health -= value
	animation_tree["parameters/conditions/hurt"] = true
	await get_tree().create_timer(0.3).timeout
	animation_tree["parameters/conditions/hurt"] = false
	
	if health <= 0:
		
		animation_tree["parameters/conditions/death"] = true
		await get_tree().create_timer(0.6).timeout
		animation_tree["parameters/conditions/death"] = false
		
		await animation_tree["parameters/conditions/death"] == false
		queue_free()
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position

func attack():
		animation_tree["parameters/conditions/attack"] = true
		await get_tree().create_timer(0.3).timeout
		animation_tree["parameters/conditions/attack"] = false
		
		await animation_tree["parameters/conditions/attack"] == false
		$Bow.shoot()
