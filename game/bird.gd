
extends RigidBody2D

var siding_left = false
var guano = preload("res://guano.scn")


func _ready():
	# Initialization here
	pass


func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()

	# Get the controls
	var move_left = Input.is_action_pressed("bird_left")
	var move_right = Input.is_action_pressed("bird_right")
	var shoot = Input.is_action_pressed("bird_shoot")
