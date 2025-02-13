extends CharacterBody2D

const BASE_SPEED = 300
const AGGRO_RANGE = 400
const MAX_HEALTH = 40
const DAMAGE_DEALT = 20
const ATTACK_CHANCE = 0.75
const XP_VALUE = 50
var health = MAX_HEALTH
var died : bool = false
@onready var speed = BASE_SPEED
@onready var player = get_node("/root/Game/Player")
@onready var animation_tree = $AnimationTree
@onready var direction = global_position.direction_to(player.global_position)
@onready var player_in_range: bool = false

func _ready():
	animation_tree.active = true

func _process(delta):
	player_in_range = $AttackRange.has_overlapping_bodies()
	animation_tree.set("parameters/conditions/idle", velocity == Vector2.ZERO)
	animation_tree.set("parameters/conditions/walk", velocity != Vector2.ZERO)

func _physics_process(delta):
	direction = global_position.direction_to(player.global_position)
	
	animation_tree["parameters/attack/blend_position"] = direction
	animation_tree["parameters/idle/blend_position"] = direction
	animation_tree["parameters/run/blend_position"] = direction
	animation_tree["parameters/hurt/blend_position"] = direction
	animation_tree["parameters/death/blend_position"] = direction
	
	if global_position.distance_to(player.global_position) < AGGRO_RANGE and not player_in_range:
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		
#
	if player_in_range and randf() < ATTACK_CHANCE * delta:
		attack()

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


func _on_attack_body_entered(body):
	if body.has_method("take_damage"):
			body.take_damage(DAMAGE_DEALT)
