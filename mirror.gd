extends MeshInstance


var mainCam=null

# Called when the node enters the scene tree for the first time.
func _ready():
	var rootplayer=get_tree().root
	mainCam = rootplayer.get_camera()



func _process(delta):
	var plane_origin = $Position3D.global_transform.origin
	var plane_norm = $Position3D.global_transform.basis.z.normalized()
	var reflectPlane = Plane(plane_norm, plane_origin.dot(plane_norm))
	var reflection_transform = $Position3D.global_transform
	
	var campos = mainCam.global_transform.origin
	
	var projpos = reflectPlane.project(campos)
	
	var mirroredpos = campos + (projpos - campos) * 2
	print(mirroredpos)
	print(campos)
	var t = Transform(Basis(), mirroredpos)
	t = t.looking_at(projpos, reflection_transform.basis.y.normalized())
	$Viewport/Camera.set_global_transform(t)
	
	var offset = reflection_transform.xform_inv(campos)
	offset = Vector2(offset.x, offset.y)
	
	$Viewport/Camera.set_frustum(2, -offset, projpos.distance_to(campos), 1000)

