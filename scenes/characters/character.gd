@icon("res://icon.svg")
extends CharacterBody3D
class_name Character
@export var mouse_sensitivity = 0.05
@export var speed = 10.0
@export var jump_velocity = 4.5
@onready var searcher_objects_raycast : RayCast3D = $RayCast3D


@onready var head = $Head
@onready var camera : Camera3D = $Head/Camera3D
var peer_id : int
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const item_scene : PackedScene =  preload("res://scenes/levels/level_1/props/item.tscn");
@onready var spawner : MultiplayerSpawner = get_tree().root.get_node("level_1").get_node("MultiplayerSpawner_Items") as MultiplayerSpawner
@onready var items_spawn : Node3D = get_tree().root.get_node("level_1").get_node("Items") as Node3D

@onready var fpc_counter : Label = $Hud/%FpcCounter


func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
func _ready():
	if is_multiplayer_authority() == false:
		set_process_unhandled_input(false)
		set_physics_process(false)
		return 
	camera.make_current()
	
	
	spawner.spawn_function = spawn_item
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	if Input.is_action_just_pressed("throw_ray"):
		throw_ray(event.global_position)
		
		
func _physics_process(delta):
	fpc_counter.text = str(Engine.get_frames_per_second()) + "/s"
	
	if searcher_objects_raycast.is_colliding():
		if Input.is_action_just_released("remove"):
			var deleted_object : Node = (searcher_objects_raycast.get_collider()) as Node
			deleted_object.queue_free()
		
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	if Input.is_action_just_released("create"):
		if (multiplayer.is_server()):
			spawn_item_2("Potion")
		else:
			spawn_item_2.rpc_id(1, "some data")
		
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

@rpc
func spawn_item_2(data : String) -> void:
	print(str(multiplayer.get_unique_id()) + " spawn2 " + data)
	var item = item_scene.instantiate()
	item.name = data
	items_spawn.add_child(item, true)
	

@rpc("any_peer")
func spawn_item(data : String) -> Node:
	print(str(multiplayer.get_unique_id()) + " spawn " + data)
	var item = item_scene.instantiate()
	item.name = data
	return item

func throw_ray(pos:Vector2):
	var dss:PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var rayparam:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	rayparam.from = camera.project_ray_origin(pos)
	var dis:int = 5
	rayparam.to = rayparam.from + camera.project_ray_normal(pos) * dis
	rayparam.collide_with_bodies = false
	rayparam.collide_with_areas = true
	
	var result:Dictionary = dss.intersect_ray(rayparam)
	if result.has("collider"):
		var subject = result.collider as Node3D
		if subject.has_method("interact"):
			subject.interact()
