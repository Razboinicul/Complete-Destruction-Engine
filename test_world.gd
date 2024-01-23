extends Node3D
var edit_interface = preload("res://UI/Obj Interface.tscn")
var paused = false
var vsync = null

func _ready():
	vsync = $UI/VSync.button_pressed
	if not vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

func _physics_process(delta):
	print($UI/FOV.value)
	if paused:
		$UI.show()
		$UI/FPS.text = "FPS: " + str(Engine.get_frames_per_second())
		Global.fov = int($UI/FOV.value)
		if $UI/FOV.value == 120:
			$UI/FOV/Label.text = "FOV: " + "Quake Player"
		elif $UI/FOV.value == 50:
			$UI/FOV/Label.text = "FOV: " + "Phone Player"
		elif $UI/FOV.value == 90:
			$UI/FOV/Label.text = "FOV: " + "Average Player"
		else:
			$UI/FOV/Label.text = "FOV: " + str($UI/FOV.value)
	else:
		$UI.hide()

func _input(event):
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		paused = true
	elif Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		paused = false
	else:
		print("Error processing pasued state, consult manual. Oh wait, there is no manual")
	#print(paused)
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

func _on_done(obj): 
	$Player.object = obj

func _on_v_sync_toggled(button_pressed):
	vsync = button_pressed
	if not vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
