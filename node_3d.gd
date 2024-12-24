extends Node3D
# Called when the node enters the scene tree for the first time.
const VU_COUNT = 10
const FREQ_MAX = 11050.0

const WIDTH = 800
const HEIGHT = 250
const HEIGHT_SCALE = 8.0
const MIN_DB = 60
const ANIMATION_SPEED = 0.1

var spectrum
var min_values = []
var max_values = []

@onready var led0: MeshInstance3D = $led0
@onready var led1: MeshInstance3D = $led1
@onready var led2: MeshInstance3D = $led2
@onready var led3: MeshInstance3D = $led3
@onready var led4: MeshInstance3D = $led4
@onready var led5: MeshInstance3D = $led5
@onready var led6: MeshInstance3D = $led6
@onready var led7: MeshInstance3D = $led7
@onready var led8: MeshInstance3D = $led8
@onready var led9: MeshInstance3D = $led9

func _draw():
	
	var w = WIDTH / VU_COUNT
	var leds = [led0, led1, led2, led3, led4, led5, led6, led7, led8, led9]
	
	for i in range(VU_COUNT):
		var min_height = min_values[i]
		var max_height = max_values[i]
		var height = lerp(min_height, max_height, ANIMATION_SPEED)	

		height = height / 50
		
		if i >= 0 and i < leds.size():
			var current_scale = leds[i].scale
			var current_height = current_scale.y
			var delta_height = height - current_height
	
			leds[i].scale = Vector3(current_scale.x, height, current_scale.z)
			leds[i].position += Vector3(0, delta_height / 2, 0)
			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var data = []
	var prev_hz = 0

	for i in range(1, VU_COUNT + 1):
		var hz = i * FREQ_MAX / VU_COUNT
		var magnitude = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clampf((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		var height = energy * HEIGHT * HEIGHT_SCALE
		data.append(height)
		prev_hz = hz

	for i in range(VU_COUNT):
		if data[i] > max_values[i]:
			max_values[i] = data[i]
		else:
			max_values[i] = lerp(max_values[i], data[i], ANIMATION_SPEED)

		if data[i] <= 0.0:
			min_values[i] = lerp(min_values[i], 0.0, ANIMATION_SPEED)

	_draw()


func _ready():
	spectrum = AudioServer.get_bus_effect_instance(0, 0)
	min_values.resize(VU_COUNT)
	max_values.resize(VU_COUNT)
	min_values.fill(0.0)
	max_values.fill(0.0)
