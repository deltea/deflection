class_name Sprite extends Sprite2D

@export_group("Dynamics")
@export var scale_dynamics: DynamicsResource
@export var rotation_dynamics: DynamicsResource

@export_group("Shadow")
@export var use_shadow = false
@export var shadow_color: Color = Color.BLACK

var target_scale = Vector2.ONE
var target_rotation_degrees = 0.0

var scale_dynamics_solver: DynamicsSolverVector
var rotation_dynamics_solver: DynamicsSolver

func _ready() -> void:
	scale_dynamics_solver = Dynamics.create_dynamics_vector(scale_dynamics)
	rotation_dynamics_solver = Dynamics.create_dynamics(rotation_dynamics)

func _process(delta: float) -> void:
	global_scale = scale_dynamics_solver.update(target_scale)
	global_rotation_degrees = rotation_dynamics_solver.update(target_rotation_degrees)
