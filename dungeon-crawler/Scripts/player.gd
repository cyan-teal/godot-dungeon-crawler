extends CharacterBody2D

signal player_shoot(player: CharacterBody2D, dir: Vector2)

const DEATH_SCREEN = "res://Scenes/death_screen.tscn"

const SPEED = 21.5 #+ 100#|$
const MAX_HEALTH = 181.09#*999
const REGEN_AMOUNT = 6.3

const SOUTH = 1
const NORTH = 2
const WEST = 3
const EAST = 4

var hit_points = MAX_HEALTH
var can_shoot = true
var playing_shoot_animation = false

func _ready():
	
	if globals.cache_player_health > 0:
		hit_points = globals.cache_player_health
		if hit_points < MAX_HEALTH:
			$RegenTimer.start()
	
	var spikes = get_tree().get_nodes_in_group("Spikes").size()
	print("There are ", spikes, " spikes in this room.")

func angle_to_cardinal_direction(angle: float) -> int:
		if angle>44 && angle<136:
			return SOUTH
		elif angle>-136 && angle<-44:
			return NORTH
		elif angle>136 || angle<-136:
			return WEST
		else:
			return EAST


func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("shoot")||Input.is_action_just_pressed("shoot_2")) and can_shoot:
		$ShootTimer.start()
		can_shoot = false
		var aim_direction = global_position.direction_to(get_global_mouse_position())
		var aim_angle = rad_to_deg(aim_direction.angle())
		playing_shoot_animation = true
		
		if Input.is_action_just_pressed("shoot_2"):
			player_shoot.emit(self, aim_direction, 0)
		else:
			player_shoot.emit(self, aim_direction, 1)
		
		match angle_to_cardinal_direction(aim_angle):
			SOUTH:
				$AnimationPlayer.play("shoot_down")
			NORTH:
				$AnimationPlayer.play("shoot_up")
			WEST:
				$AnimationPlayer.play("shoot_left")
			EAST:
				$AnimationPlayer.play("shoot_right")
	
	if not playing_shoot_animation:
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = (direction * SPEED)
		# $Camera.rotation = deg_to_rad(rad_to_deg(direction.angle())+90
		
		if direction.length() == 0.0:
			$AnimationPlayer.play("idle")
		else:
			var angle = rad_to_deg(direction.angle())
			match angle_to_cardinal_direction(angle):
				SOUTH:
					$AnimationPlayer.play("move_down")
				NORTH:
					$AnimationPlayer.play("move_up")
				WEST:
					$AnimationPlayer.play("move_left")
				EAST:
					$AnimationPlayer.play("move_right")
	

func _physics_process(_delta: float) -> void: 
	velocity = Vector2(velocity.x*0.9, velocity.y*0.9)
	move_and_slide()

func take_damage(damage: int) -> void:
	if $InvincibilityTimer.time_left == 0:
		$Sprite2D.self_modulate = Color(1, 0.0, 0.0, 1)
		$InvincibilityTimer.start(0.9)
		if hit_points - damage <= 0 && (hit_points - damage)*-1 < hit_points/2 && hit_points >= MAX_HEALTH/6:
			hit_points = randi_range(1, 3)
		else:
			hit_points -= damage
		globals.score -= 5
		# print(globals.score)
		$HurtTimer.start(0.1)
		$RegenTimer.start(4.3)


func _on_regen_timer_timeout() -> void:
	$Sprite2D.self_modulate = Color(1, 1, 1, 1)
	hit_points = min(hit_points + REGEN_AMOUNT, MAX_HEALTH)
	if hit_points < MAX_HEALTH:
		$RegenTimer.start()


func _on_hurt_timer_timeout() -> void:
	if hit_points <= 0:
		print("Game over")
		# get_tree().current_scene.queue_free()
		get_tree().call_deferred("change_scene_to_file", DEATH_SCREEN)
		
	$Sprite2D.self_modulate = Color(0.85, 0.85, 1, 0.9)


func _on_shoot_timer_timeout() -> void:
	can_shoot = true
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	playing_shoot_animation = !(anim_name == "shoot_up" || anim_name == "shoot_down" || anim_name == "shoot_left" || anim_name == "shoot_right")
	
