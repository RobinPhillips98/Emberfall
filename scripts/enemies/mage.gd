extends CharacterBody2D

const BASE_SPEED = 200
const AGGRO_RANGE = 500
const EVADE_RANGE = AGGRO_RANGE / 2
const COMBAT_RANGE = EVADE_RANGE + 100
const MAX_HEALTH = 20
const XP_VALUE = 150
const HEAL_VALUE = 10
var health = MAX_HEALTH
var died : bool = false
@onready var speed = BASE_SPEED
@onready var player = get_node("/root/Game/Player")
@onready var animation_tree = $AnimationTree
@onready var direction = global_position.direction_to(player.global_position)

func _ready():
	animation_tree.active = true
	
func _process(delta):
	animation_tree.set("parameters/conditions/idle", velocity == Vector2.ZERO)
	animation_tree.set("parameters/conditions/walk", velocity != Vector2.ZERO)
	

func _physics_process(delta):
	if global_position.distance_to(player.global_position) < EVADE_RANGE:
		direction = -global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
	elif global_position.distance_to(player.global_position) < AGGRO_RANGE and global_position.distance_to(player.global_position) > COMBAT_RANGE:
		direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
	else:
		direction = global_position.direction_to(player.global_position)
		velocity = Vector2.ZERO
	
	animation_tree["parameters/heal/blend_position"] = direction
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


func _on_heal_timer_timeout() -> void:
	var allies_in_range = %HealRadius.get_overlapping_bodies()
	
	if allies_in_range.size() > 0:
		var lowest_health_ally = allies_in_range[0]
		for i in range(allies_in_range.size()):
			if allies_in_range[i].get_health() < lowest_health_ally.get_health():
				lowest_health_ally = allies_in_range[i]
		heal(lowest_health_ally)
	
func heal(target):
		animation_tree["parameters/conditions/heal"] = true
		await get_tree().create_timer(0.7).timeout
		animation_tree["parameters/conditions/heal"] = false
		if target.has_method("be_healed"):
			target.be_healed(HEAL_VALUE)
