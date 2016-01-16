
extends RigidBody2D


func _on_body_enter(body):
	self.get_node("Sprite").hide()
	self.get_node("Particles2D").set_emitting(true)
	self.get_node("Timer").start()


func _on_Timer_timeout():
	self.queue_free()
