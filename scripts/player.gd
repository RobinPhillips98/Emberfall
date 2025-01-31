extends CharacterBody2D

signal health_depleted

# Attributes
var max_health: float = 100.0
var max_mana: float = 100.0
var max_stamina: float = 50.0
var health : float = max_health
var mana: float = max_mana
var stamina: float = 0
var stamina_regen_rate: float = 10

#Equipment
var defense : float # Should be between 0.0 and 1.0
var money: int = 0
@export var inv: Inv

#Experience and Level
const LEVEL_UP_VALUE : int = 1000
const MAX_LEVEL: int = 4
var xp: int = 0
var level: int = 1

func _ready():
	defense = inv.slots[1].item.defense

func _process(delta):
	%HealthBar.value = health
	%ManaBar.value = mana
	%StaminaBar.value = stamina
	
	if stamina < max_stamina:
		stamina += stamina_regen_rate * delta

	if Input.is_action_just_pressed('hotkey_1') and inv.slots[3].amount > 0:
		drink_potion("health_potion")

	if Input.is_action_just_pressed('hotkey_2') and inv.slots[4].amount > 0:
		drink_potion("mana_potion")

func _physics_process(delta):
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()

	if velocity.length() > 0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()

	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		if health <= 0.0:
			health_depleted.emit()

func drink_potion(type):
	match type:
		"health_potion":
			health += max_health * .3
			if health > max_health:
				health = max_health
			inv.remove(3)
		"mana_potion":
			modify_mana(max_mana * .3)
			inv.remove(4)
	
	

func take_damage(damage):
	damage *= (1 - defense)
	
	health -= damage
	
	if health <= 0.0:
		health_depleted.emit()
		
func modify_mana(value):
	mana += value
	if mana < 0:
		mana = 0
	elif mana > max_mana:
		mana = max_mana
	
func get_mana():
	return mana

func set_defense(value):
	defense = value
	
func gain_xp(value):
	xp += value
	if xp >= LEVEL_UP_VALUE:
		level_up()
	
func gain_money(value):
	money += value
	
func get_money():
	return money

func level_up():
	if level >= MAX_LEVEL:
		return
		
	gain_xp(LEVEL_UP_VALUE * -1)
	level += 1
	
	max_health += 100
	%HealthBar.max_value = max_health
	health += 100
	
	max_mana += 50.0
	%ManaBar.max_value = max_mana
	mana +=50
	if %ManaBar.visible == false:
		%ManaBar.visible = true
	
	max_stamina += 25
	%StaminaBar.max_value = max_stamina
	stamina += 25
	
	# TODO: gaining new abilities

func collect(item):
	inv.insert(item)
