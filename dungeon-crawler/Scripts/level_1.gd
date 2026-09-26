extends Node2D

const PLAYER_ARROW_SCENE = preload("res://Scenes/player_arrrow.tscn")
const PLAYER_HOMING_ARROW_SCENE = preload("res://Scenes/player_homing_arrrow.tscn")
const BLUE_SLIME_PROJECTILE_SCENE = preload("res://Scenes/blue_slime_projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_player_shoot(player: CharacterBody2D, dir: Vector2, type: int) -> void:
	var arrow
	if type == 0:
		arrow = PLAYER_HOMING_ARROW_SCENE.instantiate()
	else:
		arrow = PLAYER_ARROW_SCENE.instantiate()
	$Projectiles.add_child(arrow)
	arrow.global_position = player.global_position
	arrow.direction = dir
	arrow.base_velocity = player.velocity

func _on_blue_slime_blue_slime_shoot(blue_slime: CharacterBody2D, dir: Vector2) -> void:
	# print("b")
	var projectile = BLUE_SLIME_PROJECTILE_SCENE.instantiate()
	$Projectiles.add_child(projectile)
	projectile.global_position = blue_slime.global_position
	projectile.direction = dir
	projectile.base_velocity = blue_slime.velocity
