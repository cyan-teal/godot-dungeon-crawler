extends Area2D

@export var next_level: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if next_level:
			get_tree().call_deferred("change_scene_to_file", next_level)
			globals.score += 100
			# print(globals.score)
			globals.cache_player_health = body.hit_points
		else:
			# body.position.y += 48
			print("No entry, sorry!")
		
