extends RigidBody2D


const SPEED = 100.0

func _physics_process(delta):
    var direction = 10
    var motion = direction * SPEED * delta