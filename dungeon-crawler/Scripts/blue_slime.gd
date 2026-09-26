extends CharacterBody2D

signal blue_slime_shoot(blue_slime: CharacterBody2D, dir: Vector2)

const SPEED = (21.5 - 19.75 - 1.1) * 0.5
const DAMAGE = 25
const REGEN_AMOUNT = 1

const coin_scene = preload("res://Scenes/coin.tscn")
const slime_scene = preload("res://Scenes/blue_slime.tscn")

var max_health = 100
var hit_points = max_health
var direction = Vector2.ZERO
var force_stop_chase = false

var drag = 1.0225


func take_damage(damage: int) -> void:
	if $InvincibilityTimer.time_left == 0:
		$Sprite2D.self_modulate = Color(1, 0.0, 0.0, 1)
		
		$InvincibilityTimer.start(0.9)
		hit_points -= damage
		$HurtTimer.start(0.1)
		$RegenTimer.start(1)

func _on_regen_timer_timeout() -> void:
	$Sprite2D.self_modulate = Color(1, 1, 1, 1)
	hit_points = min(hit_points + REGEN_AMOUNT, max_health)
	if hit_points < max_health:
		$RegenTimer.start()

func _on_hurt_timer_timeout() -> void:
	if hit_points <= 0:
		if scale.length() < Vector2(0.42, 0.42).length():
			drop_coin(randi_range(1,2))
		else:
			clone()
	$Sprite2D.self_modulate = Color(0.85, 0.85, 1, 0.9)

func clone() -> void:
	var instance = slime_scene.instantiate()
	instance.name = "BlueSlime"
	instance.position = Vector2(position.x+randi_range(-10*scale.x,10*scale.x), position.y+randi_range(-10*scale.y,10*scale.y))
	instance.scale = Vector2(scale.x/1.23, scale.y/1.23)
	instance.max_health = max_health/2
	scale = Vector2(scale.x/1.23, scale.y/1.23)
	get_tree().current_scene.add_child(instance)

func drop_coin(num: int) -> void:
	for i in num:
		var instance = coin_scene.instantiate()
		instance.position = Vector2(position.x+randi_range(-10*scale.x,10*scale.x), position.y+randi_range(-10*scale.y,10*scale.y))
		get_tree().current_scene.add_child(instance)
	queue_free()

func _physics_process(delta: float) -> void:
	$Sprite2D.flip_h = velocity.x <= 0
	
	var target: CharacterBody2D
	for body in $Area2D.get_overlapping_bodies():
		if body.name == "Player":
			target = body
			break
	
	if target && !force_stop_chase:
		if $ChaseTimer.time_left == 0:
			$ChaseTimer.start()
		$AnimationPlayer.play("chase")
		
		velocity = Vector2(velocity.x/drag, velocity.y/drag)
		direction = position.direction_to(target.position)
		velocity += direction * SPEED
		var collision = move_and_collide(velocity * delta)
		if collision:
			var body = collision.get_collider()
			if body.has_method("take_damage"):
				if body.SPEED != SPEED:
					body.take_damage(DAMAGE) 
	else:
		$AnimationPlayer.play("idle")
		move_and_collide(velocity * delta)
	


func _on_chase_timer_timeout() -> void:
	$IdleTimer.start()
	var path = $"../Player"
	var aim_direction = global_position.direction_to(path.position)
	var aim_angle = rad_to_deg(aim_direction.angle())
	if get_tree().root.has_node("Level1/BlueSlime"):
		get_tree().root.get_node("Level1/BlueSlime").blue_slime_shoot.emit(self, aim_direction)
	force_stop_chase = true
	

func _on_idle_timer_timeout() -> void:
	force_stop_chase = false
	

func _on_invincibility_timer_timeout() -> void:
	pass
