extends Area2D

const MOVE_SPEED = 200
const BASE_DAMAGE = float(50)/MOVE_SPEED

var direction = Vector2.ZERO
var base_velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += (direction * (MOVE_SPEED * delta))
	global_position += base_velocity * delta
	rotation = direction.angle()


func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		if body.has_method("take_damage"):
			var net_speed = base_velocity + (direction * MOVE_SPEED)
			var delta = Engine.get_main_loop().root.get_process_delta_time()
			var velocity_difference = Vector2(net_speed - body.velocity).length()
			
			body.take_damage(BASE_DAMAGE * velocity_difference)
			# print(BASE_DAMAGE * velocity_difference)
		queue_free()
