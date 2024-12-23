extends Node3D
# Called when the node enters the scene tree for the first time.
const VU_COUNT = 8
const FREQ_MAX = 11050.0

const WIDTH = 800
const HEIGHT = 250
const HEIGHT_SCALE = 8.0
const MIN_DB = 60
const ANIMATION_SPEED = 0.1

var spectrum
var min_values = []
var max_values = []

@onready var led1: MeshInstance3D = $led1
@onready var led2: MeshInstance3D = $led2
@onready var led3: MeshInstance3D = $led3
@onready var led4: MeshInstance3D = $led4

@onready var led5: MeshInstance3D = $led5
@onready var led6: MeshInstance3D = $led6
@onready var led7: MeshInstance3D = $led7
@onready var led8: MeshInstance3D = $led8

func _draw():
	#
	#var led = get_node('led').duplicate(true)
	#led.position.x = 1.2
	#led.position.y = 2
	#led.position.z = 0
	#add_child(led)
	#
	#
	#
	#for child in get_children():
		#if child.name.substr(0,3) == "led" :
			#print(child.name)
			#
			#
			#await get_tree().create_timer(0.5).timeout
			#child.mesh.material.albedo_color = BLUE
				#
	
	var w = WIDTH / VU_COUNT
	for i in range(VU_COUNT):
		var min_height = min_values[i]
		var max_height = max_values[i]
		var height = lerp(min_height, max_height, ANIMATION_SPEED)

		#Rect2 Rect2(x: float, y: float, width: float, height: float)
		#draw_rect(
				#Rect2(w * i, HEIGHT - height, w - 2, height),
				#Color.from_hsv(float(VU_COUNT * 0.6 + i * 0.5) / VU_COUNT, 0.5, 0.6)
		#)
		#
		
		
		
		if i == 0:
			led1.scale = Vector3(1, height/50, 1) 
	
		if i == 1:
			led2.scale = Vector3(1, height/50, 1) 

		if i == 2:
			led3.scale = Vector3(1, height/50, 1) 
		
		if i == 3:
			led4.scale = Vector3(1, height/50, 1) 	

		if i == 4:
			led5.scale = Vector3(1, height/50, 1) 
	
		if i == 5:
			led6.scale = Vector3(1, height/50, 1) 

		if i == 6:
			led7.scale = Vector3(1, height/50, 1) 
		
		if i == 7:
			led8.scale = Vector3(1, height/50, 1) 	

			
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

	# Sound plays back continuously, so the graph needs to be updated every frame.
	#queue_redraw()
	_draw()


func _ready():
	spectrum = AudioServer.get_bus_effect_instance(0, 0)
	min_values.resize(VU_COUNT)
	max_values.resize(VU_COUNT)
	min_values.fill(0.0)
	max_values.fill(0.0)
