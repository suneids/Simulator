extends CharacterBody3D


@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D
@export var movement_speed : int = 3
@export var point : Marker3D
func _ready():
	pass
	



func _physics_process(_delta):
	navigation_agent.target_position = point.global_position
	var map_iteration_id : int =  NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map())
	if map_iteration_id == 0:
		#print("Навигация не синхронизируется")
		return
	if navigation_agent.is_navigation_finished():
		return
	
	var next_path_position : Vector3 = navigation_agent.get_next_path_position()
	var new_velocity : Vector3 = global_position.direction_to(next_path_position) * movement_speed
	velocity = new_velocity
	move_and_slide()
	




#func _on_velocity_computed(safe_velocity : Vector3):
	#velocity = safe_velocity
