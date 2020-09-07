extends Node

const POPUP_SCENE = preload("res://Pause.tscn")
var popup = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if popup == null:
			popup = POPUP_SCENE.instance()
			
			
