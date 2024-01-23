extends Control
#Define the object that we want to modify the values of
var object: Node3D = Node3D.new()
signal done(object)

func _ready():
	#Set rotation values
	$"Rot/Rotation X".value = object.rotation_degrees.x
	$"Rot/Rotation Y".value = object.rotation_degrees.y
	$"Rot/Rotation Z".value = object.rotation_degrees.z
	#Set scale values
	$"Scale/Scale X".value = object.scale.x
	$"Scale/Scale Y".value = object.scale.y
	$"Scale/Scale Z".value = object.scale.z
	
func _process(delta):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#Rotate the boject
	object.rotation_degrees.x = $"Rot/Rotation X".value
	object.rotation_degrees.y = $"Rot/Rotation Y".value
	object.rotation_degrees.z = $"Rot/Rotation Z".value
	#Set rotation labels
	$"Rot/Rotation X/Label".text = "Rotation X: "+str($"Rot/Rotation X".value)
	$"Rot/Rotation Y/Label".text = "Rotation Y: "+str($"Rot/Rotation Y".value)
	$"Rot/Rotation Z/Label".text = "Rotation Z: "+str($"Rot/Rotation Z".value)
	#Scale the object
	object.scale.x = $"Scale/Scale X".value
	object.scale.y = $"Scale/Scale Y".value
	object.scale.z = $"Scale/Scale Z".value
	#Set scale labels
	$"Scale/Scale X/Label".text = "Scale X: "+str($"Scale/Scale X".value)
	$"Scale/Scale Y/Label".text = "Scale Y: "+str($"Scale/Scale Y".value)
	$"Scale/Scale Z/Label".text = "Scale Z: "+str($"Scale/Scale Z".value)

func _input(event):
	#Free the object when ESC is pressed
	if event.is_action_pressed("ui_cancel"): free()

func _on_done_pressed():
	#Free the object when The Done button is pressed
	emit_signal("done", object)
	queue_free()
