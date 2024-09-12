extends Node3D
@onready var control_panel: Node3D = $".."
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var lbl: Label3D = $MeshInstance3D/Label3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lbl.text = "✕"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func interact():
	control_panel.clear_input()
