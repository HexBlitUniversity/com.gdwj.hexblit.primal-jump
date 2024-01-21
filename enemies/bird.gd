extends CharacterBody2D

@onready var bird_animation = $bird_animation
const SPEED = 150.0
var direction = -1

#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	var notifier = VisibleOnScreenNotifier2D.new()
	add_child(notifier)
	bird_animation.play("default")
	notifier.connect("screen_entered",_on_screen_entered)
	notifier.connect("screen_exited", _on_screen_exited)
	

func _physics_process(delta):
	
 
	# Add the gravity.
	#if not is_on_floor():
	#	velocity.y += gravity * delta

	# Handle jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
	
	velocity.x = direction * SPEED
	move_and_slide()
	
func _on_screen_entered():
	pass
func _on_screen_exited():
	direction = -direction
	
