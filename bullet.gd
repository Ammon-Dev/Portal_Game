extends Area

var speed = 10 #bullet speed
var damage #damage var to be used later

var time = 0 #timer
var kill = 4 #time the bullet can exist

var hit = false #if it has hit

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered",self,"collided") #do collided function on hit


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction = global_transform.basis.x.normalized() #gets the direction of the bullet
	global_translate(direction * speed * delta) #translates with speed
	
	time += delta #time increased every second
	if time >= kill: #if existed longer than 4 seconds
		queue_free() #delete bullet

func collided(body):
	if hit == false: #if not hit
		if body.has_method("bullet_hit"): #if a button
			body.bullet_hit() #do the method
	
	hit = true #in case I need it in the future
	queue_free() #delete the bullet


