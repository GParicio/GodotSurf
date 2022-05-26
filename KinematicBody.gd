extends KinematicBody
class_name Movement



export var mouse_sensitivity :=  0.2
export var gravity_multiplier := 3.0
export var speed := 10
export var acceleration := 8
export var deceleration := 10
export(float, 0.0, 1.0, 0.05) var air_control := 0.3
export var jump_height := 10
var direction := Vector3()
var input_axis := Vector2()
var velocity := Vector3()
var snap := Vector3()
var up_direction := Vector3.UP
var stop_on_slope := true
onready var floor_max_angle: float = deg2rad(45.0)
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
onready var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)

onready var head = $Head

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
		
#		self.get_position_in_parent() = Vector3(10,10,10)
  
#		
	
func _physics_process(delta) -> void:
	input_axis = Input.get_vector("move_back", "move_forward",
			"move_left", "move_right")
		
	
	direction_input()
	
	if velocity.y < -125: #150 también funciona pero tarda más
		velocity.y = 0
		translation = Vector3(10,30,0)
#		get_tree().reload_current_scene() # Quits the game
	
	if is_on_floor():
		snap = -get_floor_normal() - get_floor_velocity() * delta
		
		# Workaround for sliding down after jump on slope
		if velocity.y < 0:
			velocity.y = 0
		
		if Input.is_action_just_pressed("jump"):
			snap = Vector3.ZERO
			velocity.y = jump_height
			$saltar2.play()
	else:
		# Workaround for 'vertical bump' when going off platform
		if snap != Vector3.ZERO && velocity.y != 0:
			velocity.y = 0
		
		snap = Vector3.ZERO
		
		velocity.y -= gravity * delta
	
	accelerate(delta)
	
	velocity = move_and_slide_with_snap(velocity, snap, up_direction, 
			stop_on_slope, 4, floor_max_angle)
	


func direction_input() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if input_axis.x >= 0.5:
		direction -= aim.z
	if input_axis.x <= -0.5:
		direction += aim.z
	if input_axis.y <= -0.5:
		direction -= aim.x
	if input_axis.y >= 0.5:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	


func accelerate(delta: float) -> void:
	# Using only the horizontal velocity, interpolate towards the input.
	var temp_vel := velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = direction * speed
	
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor():
		temp_accel *= air_control
	
	temp_vel = temp_vel.linear_interpolate(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z
	



#func _on_Entrance_body_entered(body):
#	self.translation = get_parent().get_mode("Position3D").translation

#func _on_Entrance_body_entered(body):
#	translation = Vector3(10,10,10)


func _on_Entrance_body_entered(_body):
	translation = get_parent().get_node("Spawn_2").translation

func _on_Muerte_body_entered(_body):
	translation = get_parent().get_node("Spawn_1").translation
#	$sonidomuerte.play()

func _on_Muerte_2_body_entered(_body):
	translation = get_parent().get_node("Spawn_2").translation
	 # Replace with function body.

#func _on_Entrance_2_body_entered(_body):
#	translation = get_parent().get_node("Spawn_2").translation

#
#func _on_Entrance_2_body_entered(body):
#	translation = get_parent().get_node("Spawn_1").translation
#	pass # Replace with function body.


func _on_Entrance_2_body_entered(body):
	translation = get_parent().get_node("Spawn_2").translation
