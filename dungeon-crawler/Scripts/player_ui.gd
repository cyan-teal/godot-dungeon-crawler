extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/VBoxContainer/HBoxContainer/ProgressBar.max_value = $"..".MAX_HEALTH
	$Control/VBoxContainer/ProgressBar.max_value = $"../ShootTimer".wait_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Control/VBoxContainer/HBoxContainer/ProgressBar.value = $"..".hit_points
	$Control/VBoxContainer/ProgressBar.value = $"../ShootTimer".time_left
