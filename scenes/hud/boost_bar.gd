extends Node2D

@onready var empty_bar = $empty_bar
@onready var healthy_bar = $healthy_bar
@onready var warning_bar = $warning_bar
@onready var red_bar = $red_bar

const HEALTHY_BOOST_VALUE = 129
const WARNING_BOOST_VALUE = 65
const CRITICAL_BOOST_VALUE = 0

var max_fuel = 192
var current_fuel = 192
var third_boost_enabled = false

signal boost_empty

# Called when the node enters the scene tree for the first time.
func _ready():
	warning_bar.visible = false
	pass # Replace with function body.

func burn_boost(amount, delta):
	# Burn Boost faster if not green
	if get_boost_status() != "green":
		amount += 10
	
	amount *= delta
	
	current_fuel -= amount
	
	if current_fuel <= 65:
		print(current_fuel)	
		emit_signal("boost_empty")
		
	clamp_fuel()
	
	

func regen_boost(amount, delta):
	
	if get_boost_status() != "green":
		amount -= 5
		
	amount *= delta
	
	current_fuel += amount
	clamp_fuel()
			
func clamp_fuel():
	current_fuel = clamp(current_fuel, 0, max_fuel)
	
func get_boost():
	if current_fuel <= 65:
		return 0

	return current_fuel
	
func get_max_fuel():
	return max_fuel
	
func get_boost_status():
	if current_fuel >= HEALTHY_BOOST_VALUE:
		return "green"	
	elif current_fuel >= WARNING_BOOST_VALUE && third_boost_enabled: 
		return "warning"
	else:
		return "critical"		
	 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	match(get_boost_status()):
		"green":
			healthy_bar.region_rect = Rect2(Vector2(0,8),Vector2(current_fuel-HEALTHY_BOOST_VALUE,8))	
		"warning":
			warning_bar.region_rect = Rect2(Vector2(0,16),Vector2(current_fuel-WARNING_BOOST_VALUE,8))
		"critical":
			red_bar.region_rect = Rect2(Vector2(0,24),Vector2(current_fuel-WARNING_BOOST_VALUE,8))
 

