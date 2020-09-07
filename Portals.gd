extends Spatial

onready var portals := [$PortalA, $PortalB] #the 2 portals
onready var links := {$PortalA: $PortalB, $PortalB: $PortalA} #a dictionary connecting one portal to the other

#was to be used for duplicates going into the portals
#var dupe := {}

func init_portal(portal: Node):#sets the connected portal's viewport to the portal's material shader
	var portal2 = links[portal] #the connected portal
	var portal2viewport: Viewport = portal2.get_node("Viewport") #that portal's viewport 
	var tex := portal2viewport.get_texture() #the viewports texture
	var mat = portal.get_node("MeshInstance").material_override #for setting the portal's material
	mat.set_shader_param("texture_albedo", tex) #sets the material shader to the viewport texture


func _ready():
	for portal in portals: #runs init for both portals
		init_portal(portal)

func get_camera(): #gets the camera of the viewport
	return get_viewport().get_camera()

func move_camera(portal): #moves the camera of the portals based on the position of the player camera
	var portal2 = links[portal] #the connected portal
	var trans = portal2.global_transform.inverse() * get_camera().global_transform #the transform of the camera relative to the connected portal
	var y := Vector3(0, 1, 0) #the y axis
	var cam = portal.get_node("Viewport/Camera") #the portals camera
	var planePos = portal.get_node("Position3D") #the transform of the portal
	
	trans = trans.rotated(y, PI) #the transform of player cam to portal rotated on y axis
	portal.get_node("CameraHolder").transform = trans #camera holder is previous transform just in case
	var camPos= portal.get_node("CameraHolder").global_transform #puts that into a var 
	portal.get_node("Viewport/Camera").global_transform = camPos #makes the camera transform the same as camera holder
	
	#var plane = portal.global_transform.xform(Plane.PLANE_XY) #makes a plane that's the same as the portal
	###
	#I tried to get the frustum plane to work to put this against walls but I ran out of time
	
	#var mesh = portal.get_node("Viewport")
	#var mainCamPos = get_tree().root.get_camera().global_transform.origin
	#var cam_dis = plane.distance_to(mainCamPos)
	
	#var offset = planePos.transform.xform_inv(mainCamPos)
	#offset = Vector2(offset.x, offset.y)
	#cam.set_frustum(2*mesh.size.x, -offset, -cam_dis, 10000)

func syncViewport(portal): #sets the viewport width correctly
	portal.get_node("Viewport").size = get_viewport().size

func _process(delta):
	for portal in portals: #does for each portal
		move_camera(portal)
		syncViewport(portal)

func makeDupe(portal: Node, body: PhysicsBody): #supposed to make and move bodies that enter the portals around
	var portal2 = links[portal] #connected portal
	var bodyPos = body.global_transform #body transform
	var portalPos = portal.global_transform #portal transform
	var portal2Pos = portal2.global_transform #connected portal transform
	var relPos = portalPos.inverse()*bodyPos #transform of body relative to the portal
	var y := Vector3(0,1,0) #y axis
	var plane = portal.global_transform.xform(Plane.PLANE_XY) #makes a plane on the portal
	
	#was going to dupe the player body and velocity and move it relative to the player
	#var clone: PhysicsBody
	#var vel: Vector3
	#if body in dupe.keys():
	#	clone = dupe[body]
	#elif body in dupe.values():
	#	return
	#else:
	#	clone = body.duplicate(0)
		#clone.mode = RigidBody.MODE_KINEMATIC
	#	dupe[body] = clone
	#	add_child(clone)
	#vel = body.velocity
	#vel = vel.rotated(y, PI)
	#var speed=50
	#clone.global_transform = portal2Pos * relPos.rotated(y, PI)
	var newPos = portal2Pos * relPos.rotated(y, PI)#position on other side of portal that's the same distance and position relative to the body and the other portal
	
	if -plane.distance_to(body.global_transform.origin)<.000000001: #if halfway through the portal
		#vel = swapPos(body, clone, vel)
		body.global_transform = newPos #move to the other portal
	#clone.move_and_slide(vel * speed, Vector3.UP)


#Not used unfortunately
func swapPos(body: PhysicsBody, clone: PhysicsBody, vel: Vector3):
	#body.sleeping = true
	#clone.sleeping = true
	var bodyPos := body.global_transform
	var clonePos := clone.global_transform
	#velocity switch not working
	#var bodyVel: Vector3 = body.velocity
	#var cloneVel: Vector3 = vel
	#clone.global_transform = bodyPos
	#vel = bodyVel
	body.global_transform = clonePos
	#body.velocity = cloneVel
	body.get_node("head/Camera").make_current()
	return vel

#old function
#func swapPos(portal: Node, body: PhysicsBody, clone: PhysicsBody):
#	var portal2=links[portal]
#	var bodyPos := body.global_transform
#	var portalPos = portal.global_transform
#	var portal2Pos = portal2.global_transform
#	var y := Vector3(0,1,0)
#	
#	var relPos = portalPos.inverse()*bodyPos
#	var newPos = portal2.global_transform * relPos.rotated(y, PI)
	
#	var plane = portal.global_transform.xform(Plane.PLANE_XY)
	
#	if -plane.distance_to(body.global_transform.origin)<.0001:
#		swapPos(body, newPos)

func _physics_process(delta):
	for portal in portals:
		for body in portal.get_node("Area").get_overlapping_bodies():#for every body in the portal area node
			makeDupe(portal, body)
		


func _on_Area_body_exitedA(body): #not used
	#if not body in dupe:
	#	return
	#var clone: Node = dupe[body]
	#dupe.erase(body)
	#dupe[body].get_node("Mesh").visible=false
	#clone.queue_free()
	pass


func _on_Area_body_exitedB(body): #not used
	#if not body in dupe:
	#	return
	#var clone: Node = dupe[body]
	#dupe.erase(body)
	#dupe[body].get_node("Mesh").visible=false
	#clone.queue_free()
	pass


