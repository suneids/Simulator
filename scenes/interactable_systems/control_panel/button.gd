extends Node3D
@export var text:String
@onready var control_panel: Node3D = $".."
@onready var label_3d: Label3D = $Label3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_3d.text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func interact():
	control_panel.add_digit(text)
