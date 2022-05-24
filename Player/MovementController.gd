extends KinematicBody
class_name MovementController

var mouse_sensitivity = 0.5


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
onready var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)
onready var cabeza = $Head
#CollisionPolygon
#CapsuleShape

#func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)




export var fast_close := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if !OS.is_debug_build():
		fast_close = false
	
	if fast_close:
		print("** Fast Close enabled in the 'L_Main.gd' script **")
		print("** 'Esc' to close 'Shift + F1' to release mouse **")
	
	set_process_input(fast_close)


func _input(event: InputEvent) -> void:
#	if event is InputEventMouseMotion:
##		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
##		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
##		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
#
#		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
#		cabeza.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
#		cabeza.rotation.x = clamp(cabeza.rotation.x, deg2rad(-90), deg2rad(90))
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit() # Quits the game
	
	if event.is_action_pressed("change_mouse_input"):
		match Input.get_mouse_mode():
			Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Capture mouse if clicked on the game, needed for HTML5
# Called when an InputEvent hasn't been consumed by _input() or any GUI item
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT && event.pressed:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every physics tick. 'delta' is constant
func _physics_process(delta) -> void:
	input_axis = Input.get_vector("move_back", "move_forward",
			"move_left", "move_right")
	
	direction_input()
	
	if velocity.y < -100:
		print("Yes, object a is very close to (x, y)")
#		Position3D=Vector3(10,10,10)
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("reload_game"):
		get_tree().reload_current_scene()
	
	if is_on_floor():
		print("1")
	else:
		print("2")
	if Input.is_action_just_pressed("reload_game"):
		print("6")
		
		
	
	if is_on_floor():
		snap = -get_floor_normal() - get_floor_velocity() * delta
		
		# Workaround for sliding down after jump on slope
		if velocity.y < 0:
			velocity.y = 0
		
		if Input.is_action_just_pressed("jump"):
			snap = Vector3.ZERO
			velocity.y = jump_height
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
	
	




