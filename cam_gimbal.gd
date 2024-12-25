extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("cam_rotation_right"):
		rotation.y += 1.0 * delta
	if Input.is_action_just_pressed("cam_rotation_left"):
		rotation.y -= 1.0 * delta
	if Input.is_action_just_pressed("cam_gimbal_up"):
		rotation.y -= 1.0 * delta
		rotation.x -= 0.3 * delta
	if Input.is_action_just_pressed("cam_gimbal_down"):
		rotation.y += 1.0 * delta
		rotation.x += 0.3 * delta
