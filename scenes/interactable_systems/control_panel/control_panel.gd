extends Node3D
@export var code_length:int
@export var code:String
@onready var lbl: Label3D = $Label3D

func add_digit(digit:String):
	if lbl.text.length() < code_length:
		lbl.text = lbl.text + digit

func check_code():
	if lbl.text == code:
		pass
	else:
		pass
	clear_input()
	
func clear_input():
	lbl.text = ""
