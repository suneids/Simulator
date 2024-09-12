extends Node3D

class_name level_1
var peer : MultiplayerPeer
var character_scene : PackedScene = preload("res://scenes/characters/character.tscn")

@export var ip_address : String = "127.0.0.1"
@export var port : int = 4444
@onready var multiplayer_spawner_players = $MultiplayerSpawner_Players
@onready var player_container : Node = $Players # спавн сюда
@onready var spawn_points = $SpawnPoints

@onready var items = $Items

func _ready():
	
	if MultiplayerManager.multiplayer_mode == Enums.MultiplayerMode.EnetMode:
		enet_setup()
		
	elif MultiplayerManager.multiplayer_mode == Enums.MultiplayerMode.SteamMode:
		steam_setup()	
		
	


func enet_setup() -> void:
	
	peer = ENetMultiplayerPeer.new()
	
	if MultiplayerManager.player_mode== Enums.PlayerMode.Host:
		# Сетап сервера Enet
		peer.set_bind_ip(ip_address)
		var err : Error = peer.create_server(port)
		
		if err == OK:
			multiplayer.multiplayer_peer = peer
			peer.peer_connected.connect(on_peer_connected)
			peer.peer_disconnected.connect(on_peer_diconnected)
			#print("Enet Хост был запущен!")
			create_character(1)
			
	elif MultiplayerManager.player_mode == Enums.PlayerMode.Client:
		var err : Error = peer.create_client(ip_address, port)
		if err != OK:
			print("Не удалось запустить клиента")
		else:
			print("Клиент запущен!!")
			multiplayer.multiplayer_peer = peer

	
func on_peer_diconnected(id : int) -> void:
	print("вышел " + str(id))

func on_peer_connected(id: int) -> void:
	print("Зашел " + str(id))
	create_character(id)
	
func create_character(id : int) -> void:
	if character_scene.can_instantiate():
		var character = character_scene.instantiate() as CharacterBody3D
		character.name = str(id)
		character.position = get_random_spawn_point(spawn_points).position
		player_container.add_child(character)
		

func get_random_spawn_point(_spawn_points : Node) -> Node3D:
	randomize()
	var random_point_index : int = randi_range(0, 	_spawn_points.get_child_count() - 1)
	return _spawn_points.get_child(random_point_index) as Node3D
	
		
func steam_setup() -> void:
	Steam.steamInitEx()
	if not Steam.isSteamRunning():
		print("Стим не запущен")
		return
		
	peer = SteamMultiplayerPeer.new()
	var err : Error = peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC, 4)
	if err == OK:
		print("Стим лобби запущен!")
		multiplayer.multiplayer_peer = self.multiplayer_peer
