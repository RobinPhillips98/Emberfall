extends Area2D

var travelled_distance = 0
var exploded: bool = false
const SPEED = 1000
const RANGE = 300
const DAMAGE = 20


func _ready():
	$Projectile.play("default")

func _physics_process(delta):
	if not exploded:
		var direction = Vector2.RIGHT.rotated(rotation)
		position += direction * SPEED * delta

		travelled_distance += SPEED * delta
		if travelled_distance > RANGE:
			explode()


#func _on_body_entered(body):
	#if body.has_method("is_enemy") or body is TileMapLayer:
		#explode()

func explode():
	if not exploded:
		exploded = true
		
		$Explosion.visible = true
		$Explosion/AnimatedSprite2D.play("default")
		$Explosion/CollisionShape2D.disabled = false
		
		await get_tree().create_timer(0.5).timeout
		queue_free()


func _on_explosion_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(DAMAGE)
