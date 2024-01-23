extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouse_sensitivity = 0.5
var object = null
@onready var pickuper = $Camera3D/RayCast3D
@onready var pickup_pos = $Camera3D/PickupPos
@onready var start_pos = global_position
var cur_pickable = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func Pickup_pickable(pickable):
	pickable.gravity_scale = 0.0
	cur_pickable = pickable
	pickable.reparent(self)
	
func Drop_pickable(pickable):
	pickable.gravity_scale = pickable.initl_grav_scl
	cur_pickable = null
	pickable.reparent(pickable.initl_parent)

func _unhandled_input(event):
	if event is InputEventKey and pickuper.is_colliding() and event.is_action_pressed("pickup") and pickuper.get_collider() is RigidBody3D:
		if not cur_pickable: Pickup_pickable(pickuper.get_collider())
		else: Drop_pickable(pickuper.get_collider())

func _physics_process(delta):
	Global.player = self
	$Camera3D.fov = Global.fov
	var obj = $Camera3D/RayCast3D.get_collider()
	if obj != null:
		if obj.has_meta("pickable"):
			if Input.is_action_pressed("select"):
				#obj.position = self.position+Vector3(0, 0, -3.5)
				if Input.is_key_label_pressed(KEY_Q):
					obj.rotation_degrees.y -= 0.5
				if Input.is_key_label_pressed(KEY_E):
					obj.rotation_degrees.y += 0.5
				if Input.is_action_pressed("ui_left"):
					obj.rotation_degrees.z += 0.5
				if Input.is_action_pressed("ui_right"):
					obj.rotation_degrees.z -= 0.5
				if Input.is_action_pressed("ui_down"):
					obj.rotation_degrees.x += 0.5
				if Input.is_action_pressed("ui_up"):
					obj.rotation_degrees.x -= 0.5
			else:
				object = obj
			#var dist = ($Camera3D/RayCast3D.get_collision_point()-$Camera3D.position)
			#var cpos = Vector3($Camera3D.position)
			#if Input.is_action_pressed("select"):
				
				#$Camera3D/RayCast3D.force_raycast_update()
				#var ndist = ($Camera3D/RayCast3D.get_collision_point()-$Camera3D.position)
				#obj.position += (ndist-dist)#.normalized()#($Camera3D/RayCast3D.get_collision_point())#.normalized()#*$Camera3D/RayCast3D.get_collision_normal()).normalized()
				#obj.position.y += ndist.y-dist.normalized().y
	else:
		object = null
	if global_position.y <= -200:
		global_position = start_pos
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	push_objects()

func push_objects():
	for col_idx in get_slide_collision_count():
		var col := get_slide_collision(col_idx)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_central_impulse(-col.get_normal() * 0.3)
			col.get_collider().apply_impulse(-col.get_normal() * 0.01, col.get_position())

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-deg_to_rad(event.relative.x) * mouse_sensitivity)
		$Camera3D.rotate_x(-deg_to_rad(event.relative.y) * mouse_sensitivity)
