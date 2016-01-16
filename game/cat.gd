
extends RigidBody2D

var HORIZONTAL_LENGTH = 150
var JUMP_LENGTH = -200

var foot

func _ready():
	set_process(true)
	
	foot = get_node("Foot")
	foot.add_exception(self)


func move(axis_velocity, direction):
	self.get_node("Sprite").set_scale(Vector2(direction, 1))
	self.set_axis_velocity(Vector2(axis_velocity, 0))


func _process(delta):
	
	# Get the controls
	var move_left = Input.is_action_pressed("cat_left")
	var move_right = Input.is_action_pressed("cat_right")
	var jump = Input.is_action_pressed("cat_jump")

	# If foot is on contact, jump, else reduce left/right moves
	if foot.is_colliding():
		if jump:		
			set_axis_velocity(Vector2(0, JUMP_LENGTH))
		if move_left:
			self.move(-HORIZONTAL_LENGTH, 1)
		if move_right:
			self.move(HORIZONTAL_LENGTH, -1)
	else:			
		if move_left:
			self.move(-HORIZONTAL_LENGTH/2, 1)
		if move_right:
			self.move(HORIZONTAL_LENGTH/2, -1)

