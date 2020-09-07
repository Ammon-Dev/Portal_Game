extends KinematicBody

export var velocity = Vector3() #keeps the player's velocities
var speed = 50 #sets the walk speed
var gravity = -.4 #sets the gravity

var rotate_speed = 0.1 #mouse sensitivity 
var camera_angle = 0 #the current vertical camera angle

var jump = false #if the player has jumped
var jump_speed = .1 #jump height
var has_contact = false #is the ray touching the ground

var count = 0 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	$Armature/Cube.visible=false #seting the player model as invisible for now

func _physics_process(delta):
	velocity.y += gravity*delta #gravity
	velocity.x = 0 #so you stop
	velocity.z = 0 #so you stop
	
	
	if Input.is_action_pressed("fwd"): #move forward
		velocity += transform.basis.z 
	if Input.is_action_pressed("back"): #move backward
		velocity += -transform.basis.z
	if Input.is_action_pressed("left"): #move left
		velocity += transform.basis.x
	if Input.is_action_pressed("right"): #move right
		velocity += -transform.basis.x
	
	#for making the gravity just far better
	if !$RayCast.is_colliding(): #if the ray is not touching the ground
			has_contact = false #player isn't touching the ground
	else:
		has_contact = true
	
	if has_contact: #if touching the ground
		velocity.y = 0 #set y to 0
		if Input.is_action_just_pressed("jump"): #if you can pressed space
			velocity.y = jump_speed #jump
	
	move_and_slide(velocity * speed, Vector3.UP) #do movements


func _unhandled_input(event):
	#mouse input
	if event is InputEventMouseMotion: #if mouse moves
		rotate_y(deg2rad(-event.relative.x*rotate_speed)) #rotates the camera horizontally
		var changev = -event.relative.y*rotate_speed #amount moved vertically
		if camera_angle+changev>-90 and camera_angle+changev<90:#can only move 90 degrees up and down
			camera_angle+=changev
			$head.rotate_x(deg2rad(-changev))#rotate vertically



