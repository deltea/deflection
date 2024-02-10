extends Node

var dynamics_solver_scene = preload("res://utils/dynamics_solver.tscn")
var dynamics_solver_vector_scene = preload("res://utils/dynamics_solver_vector.tscn")

func create_dynamics(dynamics: DynamicsResource):
	var solver = dynamics_solver_scene.instantiate() as DynamicsSolver
	solver.f = dynamics.f
	solver.z = dynamics.z
	solver.r = dynamics.r
	get_tree().root.call_deferred("add_child", solver)
	return solver

func create_dynamics_vector(dynamics: DynamicsResource):
	var solver = dynamics_solver_vector_scene.instantiate() as DynamicsSolverVector
	solver.f = dynamics.f
	solver.z = dynamics.z
	solver.r = dynamics.r
	get_tree().root.call_deferred("add_child", solver)
	return solver

