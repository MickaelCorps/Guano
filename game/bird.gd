
extends RigidBody2D

# Lift-to-drag ratio frictions
const LTD = 300
const SHIT_COOLDOWN = 0.5
const STUN_COOLDOWN = 2
const START_SPEED = Vector2(100, 0)
const MAX_SPEED = 500
const STALLING_SPEED = 15
const TURNING_SPEED = PI
const HOPPING_VECT = Vector2(50, 50)

var siding_left = false
var guano = preload("res://guano.scn")
onready var cloaca = self.get_node("cloaca")
var cur_shit_cooldown = 0
var cur_stun_cooldown = 0

var airspeed = 100
var horizon = Vector2(0, 1)
var stalling = false
var scale = Vector2(1,1)


func _ready():
	self.set_linear_velocity(START_SPEED)


func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()

	var new_siding_left = siding_left

	# Get the controls
	var move_left = Input.is_action_pressed("bird_left")
	var move_right = Input.is_action_pressed("bird_right")
	var shoot = Input.is_action_pressed("bird_shoot")

	if shoot and not cur_shit_cooldown:
		cur_shit_cooldown = SHIT_COOLDOWN
		var gi = guano.instance()
		cloaca.get_pos()
		var ss
		if siding_left:
			ss = -1.0
		else:
			ss = 1.0
		var pos = self.get_pos() + cloaca.get_pos() * Vector2(ss,1.0)
		gi.set_pos(pos)
		# Rotate the guano according to bird's speed vector
		gi.set_rot(atan2(s.get_total_gravity().y, lv.x))
		gi.set_linear_velocity(lv)
		self.get_parent().add_child(gi)
#		get_node("sound").play("shit")
	elif cur_shit_cooldown:
		cur_shit_cooldown -= step
		if cur_shit_cooldown < 0:
			cur_shit_cooldown = 0

	if move_right:
		horizon = horizon.rotated(-TURNING_SPEED * step)
	if move_left:
		horizon = horizon.rotated(TURNING_SPEED * step)
	var horizon_angl = horizon.angle()

	if stalling:
		print(horizon.dot(lv.normalized()))
		if airspeed > STALLING_SPEED and horizon.dot(lv.normalized()) < -0.8:
			print("RECOVEEEEEER")
			# Recovering the stall
			stalling = false
			self.set_mode(MODE_CHARACTER)  # switch back to Character mode
		else:
			# Freely apply gravity
			lv += s.get_total_gravity() * step
	elif airspeed < STALLING_SPEED:
		# Start stalling
		stalling = true
		self.set_mode(MODE_RIGID)  # switch to rigid mode
	else:
		# Compute vertical and horizontal speed by projection
		var vy = -sin(horizon_angl) * (airspeed + s.get_total_gravity().y * step) + LTD * step
#		print(vy, "  ", self.get_pos().y, "  ", s.get_total_gravity().y)
		lv = Vector2(cos(horizon_angl) * airspeed, vy)

	# Compute new airspeed for next step
	airspeed = lv.length()
	if airspeed > MAX_SPEED:
		airspeed = MAX_SPEED

	# Bird's rigid body is in character mode, then rotation is reseted each step 
	self.set_rot(horizon_angl)

	var new_siding_left = horizon_angl > PI/2 or horizon_angl < -PI/2
	if new_siding_left != siding_left:
		if new_siding_left:
			self.get_node("Sprite").set_scale(Vector2(1,-1))
		else:
			self.get_node("Sprite").set_scale(Vector2(1,1))
		siding_left=new_siding_left  # Update siding
#
	self.set_scale(scale)
	s.set_linear_velocity(lv)


func airspeed():
	var angle = self.get_rot()
	var velocity = self.get_linear_velocity()
	var v = sqrt(velocity.x*velocity.x + velocity.y*velocity.y)
	var velAngle = atan2(velocity.y, velocity.x)
	return v * cos(angle - velAngle)
