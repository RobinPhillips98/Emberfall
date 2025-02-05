extends CharacterBody2D

const BASE_SPEED = 300
const AGGRO_RANGE = 250
const ATTACK_RANGE = 60
var health = 30
@onready var speed = BASE_SPEED
@onready var player = get_node("/root/Game/Player")
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var direction = global_position.direction_to(player.global_position)

func _process(delta):
	animation_tree.set("parameters/conditions/idle", velocity == Vector2.ZERO)
	animation_tree.set("parameters/conditions/walk", velocity != Vector2.ZERO)

func _physics_process(delta):
	direction = global_position.direction_to(player.global_position)
	if global_position.distance_to(player.global_position) < AGGRO_RANGE and global_position.distance_to(player.global_position) > ATTACK_RANGE:
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		
	if direction.x > 0:
		$Sprite2D.flip_h = false
	elif direction.x < 0:
		$Sprite2D.flip_h = true
	
	if global_position.distance_to(player.global_position) <= ATTACK_RANGE and randf() < 0.5 * delta:
		attack()

func take_damage(value):
	health -= value
	animation_tree["parameters/conditions/hurt"] = true
	await get_tree().create_timer(0.3).timeout
	animation_tree["parameters/conditions/hurt"] = false
	
	if health <= 0:
		
		animation_tree["parameters/conditions/death"] = true
		await get_tree().create_timer(0.6).timeout
		animation_tree["parameters/conditions/death"] = false
		
		queue_free()
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position

func get_health():
	return health

func be_healed(value):
	health += value

#func _on_timer_timeout() -> void:
	#if global_position.distance_to(player.global_position) < ATTACK_RANGE:
		#attack()

func attack():
		animation_tree["parameters/conditions/attack"] = true
		await get_tree().create_timer(0.3).timeout
		animation_tree["parameters/conditions/attack"] = false


func _on_attack_body_entered(body):
	if body.has_method("take_damage"):
			body.take_damage(20)
