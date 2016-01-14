
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

export(String) var destination
var destination_node


func _ready():
	# Initialization here
	destination_node = self.get_node(destination)


func _on_body_enter(body):
	print(body)
#	if (not taken and body extends preload("res://player.gd")):
#		get_node("anim").play("taken")
#		taken=true
#