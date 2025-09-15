extends Area2D

@export var boost_strength: float = 2000.0

# Keeps track of how many bodies are inside booster
var bodies_inside = []

func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D: # Only appends body if it is a RigidBody2D, which is what the players are
		bodies_inside.append(body)

func _on_body_exited(body: Node) -> void:
	bodies_inside.erase(body)

func _physics_process(delta: float) -> void:
	# Does nothing if there are no bodies inside booster
	if bodies_inside.is_empty():
		return

	# Transforms the direction of the force to be relative the booster's up, no matter its rotation
	var boost_dir: Vector2 = -transform.y.normalized()
	# iterates through each body inside the booster and applies a force to it
	for body in bodies_inside:
		body.apply_central_force(boost_dir * boost_strength)
