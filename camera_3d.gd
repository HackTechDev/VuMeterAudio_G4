extends Camera3D

@onready var audio_stream_player: AudioStreamPlayer = $"../../../AudioStreamPlayer"


# Variables pour gérer le volume
var volume_db := 0.0  # Volume en décibels
const VOLUME_STEP := 2.0  # Incrément ou décrément en dB
const MAX_VOLUME := 5.0  # Volume maximal (0 dB)
const MIN_VOLUME := -80.0  # Volume minimal (-80 dB, généralement silence)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Augmenter le volume
	if Input.is_action_just_pressed("increase_volume"):
		volume_db = clamp(volume_db + VOLUME_STEP, MIN_VOLUME, MAX_VOLUME)
		audio_stream_player.volume_db = volume_db
		print("Volume augmenté : ", volume_db)

	# Diminuer le volume
	if Input.is_action_just_pressed("decrease_volume"):
		volume_db = clamp(volume_db - VOLUME_STEP, MIN_VOLUME, MAX_VOLUME)
		audio_stream_player.volume_db = volume_db
		print("Volume diminué : ", volume_db)
