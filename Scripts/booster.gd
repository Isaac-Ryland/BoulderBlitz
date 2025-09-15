extends Area2D

@export var boost_strength: float = 2000.0

var bodies_inside = []

func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D:
		bodies_inside.append(body)

func _on_body_exited(body: Node) -> void:
	bodies_inside.erase(body)

func _physics_process(delta: float) -> void:
	if bodies_inside.is_empty():
		return

	var boost_dir: Vector2 = -transform.y.normalized()
	for body in bodies_inside:
		if is_instance_valid(body): # Can never be too safe
			body.apply_central_force(boost_dir * boost_strength)
