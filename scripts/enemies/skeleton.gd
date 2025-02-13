extends CharacterBody2D

const BASE_SPEED = 300
const AGGRO_RANGE = 750
const EVADE_RANGE = AGGRO_RANGE / 2
const ATTACK_RANGE = EVADE_RANGE * 1.5
const ATTACK_CHANCE = .5
const MAX_HEALTH = 30
const XP_VALUE = 100
var health = MAX_HEALTH
var died: bool = false
@onready var speed = BASE_SPEED
@onready var player = get_node("/root/Game/Player")
@onready var animation_tree = $AnimationTree
@onready var direction = global_position.direction_to(player.global_position)
	
func _process(delta):
	animation_tree.set("parameters/conditions/idle", velocity == Vector2.ZERO)
	animation_tree.set("parameters/conditions/walk", velocity != Vector2.ZERO)
	
	if global_position.distance_to(player.global_position) > EVADE_RANGE and global_position.distance_to(player.global_position) < ATTACK_RANGE and randf() < ATTACK_CHANCE * delta:
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
		
	animation_tree["parameters/attack/blend_position"] = direction
	animation_tree["parameters/idle/blend_position"] = direction
	animation_tree["parameters/run/blend_position"] = direction
	animation_tree["parameters/hurt/blend_position"] = direction
	animation_tree["parameters/death/blend_position"] = direction

func take_damage(value):
	health -= value
	animation_tree["parameters/conditions/hurt"] = true
	await get_tree().create_timer(0.3).timeout
	animation_tree["parameters/conditions/hurt"] = false
	
	if health <= 0:
		if not died:
			player.gain_xp(XP_VALUE)
			died = true
		
		$DeathSound.play()
		animation_tree["parameters/conditions/death"] = true
		await get_tree().create_timer(0.6).timeout
		animation_tree["parameters/conditions/death"] = false
		
		await animation_tree["parameters/conditions/death"] == false
		queue_free()

func get_health():
	return health

func be_healed(value):
	health += value
	if health > MAX_HEALTH:
		health = MAX_HEALTH

func attack():
		animation_tree["parameters/conditions/attack"] = true
		await get_tree().create_timer(0.3).timeout
		animation_tree["parameters/conditions/attack"] = false
