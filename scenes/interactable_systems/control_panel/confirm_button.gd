extends Node3D
@onready var control_panel: Node3D = $".."
@onready var label_3d: Label3D = $MeshInstance3D/Label3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_3d.text = "✓"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func interact():
	control_panel.check_code()
