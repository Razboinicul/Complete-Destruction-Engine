extends CharacterBody3D

var ENEMY_SPEED= 2
func _physics_process(delta):
	var player_position = Global.player.global_transform.origin
	var direction_to_target = ((player_position - global_transform.origin)-Vector3(2, 0, 2)).normalized()
	velocity = direction_to_target * ENEMY_SPEED
	global_position.y = player_position.y-1
	var target = Global.player
	look_at(target.global_position)
	self.rotation_degrees.y += 90
	self.rotation_degrees.x = 0
	self.rotation_degrees.z = 0
	if velocity != Vector3.ZERO:
		move_and_slide()
