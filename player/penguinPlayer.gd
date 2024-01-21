extends CharacterBody2D

@export var MAX_SPEED = 1200	
@onready var penguin = $penguin
@onready var booster = $booster
@onready var boost_bar = $boost_bar

@onready var scoring = $ScoreSystem
@onready var restart = $finish_scene/restart
var overloaded = false

const SPEED = 100.0
const JUMP_VELOCITY = -300


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity_setting = ProjectSettings.get_setting("physics/2d/default_gravity")

var y = 0
var x = 0
var jumpCounter = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	booster.visible = false
	penguin.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	pass

func _physics_process(delta):	
	gravity(delta)
	
	jump(delta)	
	use_booster(delta)
	movement(delta)
	move_and_slide()

func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_setting * delta
	elif penguin.animation == "falling":
		penguin.play("pause")
		
	if is_on_floor():
		boost_bar.regen_boost(60,delta)
		jumpCounter = 0
		booster.visible = false
	
	if overloaded:
		if boost_bar.get_boost() >= boost_bar.get_max_fuel():
			overloaded = false
			penguin.animation = "pause"
	
	

func jump(delta):
	if overloaded:
		return
		
	if Input.is_action_just_pressed("ui_accept") && is_on_floor():
		velocity.y = JUMP_VELOCITY
		penguin.play("Jump")		
		jumpCounter = 1
	elif Input.is_action_just_pressed("ui_accept"):
		jumpCounter += 1
	elif !is_on_floor() && !overloaded:
		penguin.play("falling")
	#else:
	#	penguin.play("pause")

func use_booster(delta):	
	
	if overloaded:
		return
	
	match(penguin.flip_h):
		true:
			booster.position.x = 5.983
		false:
			booster.position.x = -3.933
	
	if  boost_bar.get_boost() <= 0 && !overloaded:
		penguin.play("falling")
		booster.visible = false
		return
	 
			
	if Input.is_action_pressed("ui_accept") && not is_on_floor():
		velocity.y = (JUMP_VELOCITY*0.5)
		booster.visible = true
		booster.play("start_boost")
		boost_bar.burn_boost(90,delta)
	elif booster.animation == "boosting":
		booster.play("boost_end")
	elif booster.animation == "boost_end" && not is_on_floor():
		penguin.play("falling")

func movement(delta):

	if overloaded:
		return
		
	var direction = Input.get_axis("ui_left","ui_right")
	 
	if !booster.visible:
		if direction == 0:
			penguin.pause()
		else:
			penguin.play("default")			
				
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:			
			penguin.flip_h = false
		else:
			penguin.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
func _on_area_2d_body_entered(body):
	pass
	
	
func _on_booster_animation_finished():
	match(booster.animation):
		"start_boost":
			booster.play("boosting")
		"boost_end":
			booster.visible = false
		"overload":
			penguin.play("default")
func return_time():
	scoring.position = Vector2(76.195,-153.978)
func pause_time():
	scoring.pause_time()
	
func finish():
	restart.visible = true
	scoring.pause_time()
	scoring.position = Vector2(-69.581,-66.936)
	scoring.scale = Vector2(2,2)
	
	
func get_time_text():
	return scoring.get_current_time_text()
	
func _on_boost_bar_boost_empty():
	print("boost end?")
	#booster.visible = false
	overloaded = true
	penguin.play("overload")
	
	





func _on_area_2d_area_entered(area):
	print("snowman enemy")
	if area.is_in_group("enemy"):
		print("snowman hurt")
		boost_bar.burn_boost(60,1)


func _on_button_pressed():	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://maps/proto_race_map.tscn")
