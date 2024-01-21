extends CharacterBody2D

@onready var snowman_animated = $"snowman-animated"
@onready var raycast_forward = $raycast_forward
@onready var raycast_bottom = $raycast_bottom
@onready var raycast_angle = $raycast_angle
@onready var collision = $collision
@onready var hurtbox = $hurtboxArea
@onready var respawnTimer = $respawn
var health = 1
const SPEED = -25.0
const JUMP_VELOCITY = -400.0
var direction = 1
var collide_bottom = false
var collide_forward = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity_setting = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	pass
	snowman_animated.play("default")

func _physics_process(delta):
	gravity(delta)
	
	if snowman_animated.animation != "default":
		return
	
	if raycast_bottom.is_colliding()  && raycast_forward.is_colliding() || !raycast_angle.is_colliding() && is_on_floor():
		if raycast_forward.get_collider() is CharacterBody2D && raycast_forward.get_collider().is_in_group("player"):
			pass
			#Add Attacking Enemy
		else:
			flipSnowman()
	
 
	velocity.x = direction * SPEED

	if snowman_animated.animation != "damaged" && snowman_animated.animation != "death" && snowman_animated.animation != "dead":
		move_and_slide()
	

	

func flipSnowman():
	scale.x = -scale.x
	direction = -direction
	
	#snowman_animated.flip_h = !snowman_animated.flip_h
	
func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_setting * delta
		
	


func _on_hurtbox_2d_body_entered(body):	
	health -= 1
	snowman_animated.stop()
	snowman_animated.play("damaged")
	
	


func _on_snowmananimated_animation_finished():
	match(snowman_animated.animation):
		"damaged":
			if health > 0:
				snowman_animated.play("default")
			else:
				disable_on_death()
				snowman_animated.play("death")
		"death":
			snowman_animated.play("dead")
			respawnTimer.start()
		"respawn":
			enable_on_respawn()
			snowman_animated.play("default")

func disable_on_death():
	hurtbox.monitoring = false
	raycast_angle.enabled = false
	raycast_bottom.enabled = false
	raycast_forward.enabled = false
	
func enable_on_respawn():
	hurtbox.monitoring = true
	raycast_angle.enabled = true
	raycast_bottom.enabled = true
	raycast_forward.enabled = true
	
		
func _on_respawn_timeout():
	health = 1
	snowman_animated.play("respawn")
	

