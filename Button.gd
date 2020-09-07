extends StaticBody


signal hit #tells other nodes it's been hit
var hit = false #says the button has not been hit


func _ready():
	$MeshInstance2.visible = false #makes the yellow button invisible



func bullet_hit():
	if !hit: #if the button has not been hit
		emit_signal("hit") #send the hit signal
		$MeshInstance.visible = false #makes the red button invisible
		$MeshInstance2.visible = true #makes the yellow button visible
		hit = true #says the button has been hit