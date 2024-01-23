extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var ENEMY_SPEED = 100
var in_area = false
var following = false
func _physics_process(delta):
	if in_area: $Control.show()
	else: $Control.hide()
	if not is_on_floor():
		velocity.y -= gravity
	if following:
		var player_position = Global.player.global_transform.origin
		var direction_to_target = (((player_position - global_transform.origin)-Vector3(2, 0, 2))*ENEMY_SPEED).normalized()
		velocity = direction_to_target * ENEMY_SPEED
		velocity.y = 0
		var target = Global.player
		look_at(target.global_position)
		self.rotation_degrees.y += 90
		self.rotation_degrees.x = 0
		self.rotation_degrees.z = 0
	velocity *= delta
	if velocity != Vector3.ZERO:
		move_and_slide()

func _input(event):
	if event.is_action_pressed("interact") and in_area:
		following = not following

func _on_area_3d_body_entered(body):
	if body != null and body.is_in_group("Player"):
		in_area = true

func _on_area_3d_body_exited(body):
	if body != null and body.is_in_group("Player"):
		in_area = false
