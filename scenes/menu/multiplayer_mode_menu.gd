extends Control

@export var player_mode_group : ButtonGroup


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_enet_multiplayer_btn_pressed():
	_set_multiplayer_mode(Enums.MultiplayerMode.EnetMode)
	set_player_mode()
	_change_scene("res://scenes/levels/level_1/location.tscn")
	
func _set_multiplayer_mode(mode : Enums.MultiplayerMode) -> void:
	MultiplayerManager.multiplayer_mode = mode

	
func _change_scene(scene_name : String) -> void:
	get_tree().change_scene_to_file(scene_name)
	
func _on_steam_multiplayer_btn_pressed():
	_set_multiplayer_mode(Enums.MultiplayerMode.SteamMode)
	_change_scene("res://scenes/levels/level_1/location.tscn")

func set_player_mode() -> void:
	var pressedButton : BaseButton = player_mode_group.get_pressed_button()
	var mode : String = pressedButton.get_meta("PlayerMode")
	if mode == "Host":
		MultiplayerManager.player_mode = Enums.PlayerMode.Host
		#print("Host set")
	elif mode == "Client":
		MultiplayerManager.player_mode = Enums.PlayerMode.Client
	elif mode == "Server":
		MultiplayerManager.player_mode = Enums.PlayerMode.Server
		#print("Server set")
