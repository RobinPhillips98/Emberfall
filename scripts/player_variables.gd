extends Node

#Base numbers
var level_up_value = 500
var max_health: float = 100.0
var max_mana: float = 0.0
var max_stamina: float = 50.0

# Attributes
var health : float = max_health
var mana: float = max_mana
var stamina: float = max_stamina
var stamina_regen_rate: float = 25
var speed = 600

#Equipment
var health_potions: int = 0
var mana_potions: int = 0

#Experience and Level
var xp: int = 0
var level: int = 1
