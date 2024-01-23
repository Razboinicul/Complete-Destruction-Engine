extends RigidBody3D
var initl_grav_scl = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var initl_parent = get_parent()
var rotation_offset = Vector3.ZERO
@export var rotation_speed = 1

func _process(delta):
	if get_parent().is_in_group("Player"):
		global_position = get_parent().pickup_pos.global_position
		global_rotation = get_parent().get_node("Camera3D").global_rotation
		global_rotation = rotation_offset
		var rot = rotation_speed * delta
		if Input.is_action_just_pressed("freeze") and get_parent().is_in_group("Player"):
			self.freeze = not freeze
		if Input.is_key_label_pressed(KEY_Q):
			rotation_offset.y -= rot
		if Input.is_key_label_pressed(KEY_E):
			rotation_offset.y += rot
		if Input.is_action_pressed("ui_left"):
			rotation_offset.z += rot
		if Input.is_action_pressed("ui_right"):
			rotation_offset.z -= rot
		if Input.is_action_pressed("ui_down"):
			rotation_offset.x += rot
		if Input.is_action_pressed("ui_up"):
			rotation_offset.x -= rot

func _ready():
	self.set_meta("pickable", true)

func _physics_process(delta):
	if global_position.y <= -200: free()
