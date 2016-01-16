
extends RigidBody2D

var HORIZONTAL_LENGTH = 150
var JUMP_LENGTH = -200

var foot

func _ready():
	set_process(true)
	
	# Initialization here
	foot = get_node("Foot")
	foot.add_exception(self)
	

func _process(delta):
	# Get the controls
	var move_left = Input.is_action_pressed("cat_left")
	var move_right = Input.is_action_pressed("cat_right")
	var jump = Input.is_action_pressed("cat_jump")

	if foot.is_colliding():
		if jump:		
			set_axis_velocity(Vector2(0, JUMP_LENGTH))
				
		if move_left:
			set_axis_velocity(Vector2(-HORIZONTAL_LENGTH, 0))
		
		if move_right:
			set_axis_velocity(Vector2(HORIZONTAL_LENGTH, 0))

