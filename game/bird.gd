
extends RigidBody2D

# Lift-to-drag ration
const LTD_RATIO = 1
const SHIT_COOLDOWN = 0.5
const SPEED = 10
const START_SPEED = Vector2(100, 0)

var siding_left = false
var guano = preload("res://guano.scn")
onready var cloaca = self.get_node("cloaca")
var cur_shit_cooldown = 0


func _ready():
	self.set_linear_velocity(START_SPEED)


func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()

	# Get the controls
	var move_left = Input.is_action_pressed("bird_left")
	var move_right = Input.is_action_pressed("bird_right")
	var shoot = Input.is_action_pressed("bird_shoot")

	if shoot and not cur_shit_cooldown:
		cur_shit_cooldown = SHIT_COOLDOWN
		var gi = guano.instance()
		cloaca.get_pos()
		var pos = self.get_pos() + self.get_node("cloaca").get_pos()
		gi.set_pos(pos)
		# Rotate the guano according to bird's speed vector
		if not lv.y:
			if lv.x >= 0:
				gi.set_rot(0)
			else:
				gi.set_rot(-PI)
		else:
			gi.set_rot(atan(lv.x/lv.y))
		gi.set_linear_velocity(self.get_linear_velocity())
		self.get_parent().add_child(gi)
#		get_node("sound").play("shit")
	elif cur_shit_cooldown:
		cur_shit_cooldown -= step
		if cur_shit_cooldown < 0:
			cur_shit_cooldown = 0

#	lv+=s.get_total_gravity()*step
#	s.set_linear_velocity(lv)
#