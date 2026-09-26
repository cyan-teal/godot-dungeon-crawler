extends CharacterBody2D

signal shoot(wizard: CharacterBody2D, dir: Vector2, speed: float, spawn_position: Vector2)

const SPEED = 21.5 - 19.75 - 1.1 + 0.55+0.7
const DAMAGE = 25
const REGEN_AMOUNT = 1

const coin_scene = preload("res://Scenes/coin.tscn")

var max_health = 100 * 7.2
var hit_points = max_health
var direction = Vector2.ZERO
var drag = 1.0225

enum State {
	IDLE,
	CHASE,
	SPAWN,
	ATTACK_1 = 1,
	ATTACK_2 = 2,
	ATTACK_3 = 3
}
var state = State.IDLE
var last_attack_state = State.ATTACK_1

func attack_1():
	print(99)
	shoot.emit(self, $ProjectileSpawnMarker.global_position.direction_to($"../Player".position), 100.0, $ProjectileSpawnMarker.global_position)
	#attack_2()
	#attack_3() 

func attack_2():
	var level = $"../.."
	var count = 16
	for i in range(count):
		var angle = (360/count)*i
		var direction = Vector2.from_angle(deg_to_rad(angle))
		shoot.emit(self, direction, 76.92, $ProjectileSpawnMarker.global_position)
		

func attack_3():
	var level = $"../.."
	var count = 48
	var direction = $ProjectileSpawnMarker.global_position.direction_to($"../Player".position)
	for i in range(count):
		shoot.emit(self, direction, randf_range(15, 95), $ProjectileSpawnMarker.global_position)
		

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
		drop_coin(8)
	$Sprite2D.self_modulate = Color(0.85, 0.85, 1, 0.9)
func drop_coin(num: int) -> void:
	for i in num:
		var instance = coin_scene.instantiate()
		instance.position = Vector2(position.x+randi_range(-10*scale.x,10*scale.x), position.y+randi_range(-10*scale.y,10*scale.y))
		get_tree().current_scene.add_child(instance)
	queue_free()



func _process(delta: float) -> void:
	var target = $"../Player"
	
	match state:
		State.IDLE:
			change_to_chase()
		State.CHASE:
			$AnimationPlayer.play("chase")
			if target and velocity.length() <= 10:
				direction = global_position.direction_to(target.global_position)
				velocity = (direction * SPEED) / delta
			velocity *= 0.965
		State.ATTACK_1:
			pass
		State.ATTACK_2:
			pass
		State.ATTACK_3:
			pass
		_:
			print("How did you get this state?")
		
	move_and_slide()


func _on_invincibility_timer_timeout() -> void:
	pass

func change_to_chase():
	print("5")
	state = State.CHASE
	$AttackCooldownTimer.start()

func _on_attack_cooldown_timer_timeout() -> void:
	print("a")
	var x = randi_range(1,3)
	print("A")
	print(x)
	match x:
		1:
			state = State.ATTACK_1
			$AnimationPlayer.play("attack_1")
			print("b")
		2:
			state = State.ATTACK_2
			$AnimationPlayer.play("attack_2")
			print("b")
		3:
			state = State.ATTACK_3
			$AnimationPlayer.play("attack_3")
			print("b")
	
