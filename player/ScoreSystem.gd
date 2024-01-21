extends Node2D

@export var counter = 0.0
var start_time = 0
var current_time = 0
var formatted_time_text = "%s%s.%s%s"
var current_time_text = ""

@onready var minutesTens = $minutesTens
@onready var minutesOnes = $minutesOnes
@onready var secondsOnes = $secondsOnes
@onready var secondsTens = $secondsTens

var paused = false


# Called when the node enters the scene tree for the first time.
func _ready():
	counter = 0
	start_time = Time.get_ticks_msec()

func _physics_process(delta):
	if paused:
		return
		
	current_time =  (Time.get_ticks_msec() - start_time) / 1000.0
	update_timer_display()
	
func update_timer_display():
	var minutes = (current_time / 60) as int
	var seconds = int(current_time as int % 60) 
	var minutes_tens = minutes / 10
	var minutes_ones = minutes % 10
	var seconds_tens = seconds / 10
	var seconds_ones = seconds % 10
	
	minutesTens.frame = minutes_tens
	minutesOnes.frame = minutes_ones
	secondsTens.frame = seconds_tens
	secondsOnes.frame = seconds_ones
	current_time_text = formatted_time_text % [minutes_tens,minutes_ones,seconds_tens, seconds_ones]
	
func pause_time():
	paused = true
	
func resume_time():
	paused = false

func get_time_total_seconds():
	return current_time
	
func get_current_time_text():
	return current_time_text
