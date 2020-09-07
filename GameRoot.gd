extends Spatial

var count = 0 #counts the number of targets hit
const target_MAX = 5 #the max number of targets
var UI_status_label #will hold the hud for targets left
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bulletMaster #loads in the bullet scene

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #freezes the mouse and makes it hidden
	bulletMaster = preload("res://bullet.tscn") #loads in the bullet scene
	UI_status_label = $HUD/Panel/Goal #holds the hud for targets left

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"): #if esc is pressed
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) #make the mouse visible
		get_tree().paused = true #pause the game expect for the pause menu
		$Pause.show() #show the pause menu
		$Pause/Button.connect("pressed", self, "resume") #when button is pressed run resume
		$Pause/Button2.connect("pressed", self, "quit") #when button2 is pressed run quit
	
	if Input.is_action_just_pressed("fire"): #when keft click is pressed
		var bullet = bulletMaster.instance() #makes a bullet
		var scene_root = get_tree().root.get_children()[0]  #adds bullet to the scene root
		scene_root.add_child(bullet) #adds bullet to the scene root
		bullet.global_transform = $character/head/gun/barrel.global_transform #sets the transform of the bullet to be the same as the gun
	
	process_UI(delta) #runs the display ui

func process_UI(delta):
	UI_status_label.text = "Targets hit: " + str(count) + "/" + str(target_MAX) #targets left displayed
	if count==5: #if all targets are hit
		get_tree().quit() #end game


func resume(): #makes the game continue
	get_tree().paused = false #makes the game keep going
	$Pause.hide() #hide the pause menu
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #hides mouse and freezes it

func quit(): #closes the game
	get_tree().quit()

func _on_Button_hit(): #when the button is hit
	count+=1 #increases buttons hit
	print(count) #prints the count
