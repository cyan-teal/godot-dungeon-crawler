extends Area2D


const DAMAGE = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		if body.has_method("take_damage"):
				body.take_damage(DAMAGE)
