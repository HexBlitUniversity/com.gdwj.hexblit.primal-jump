extends Node2D

@onready var penguinPlayer = $penguinPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_area_2d_area_entered(area):
	penguinPlayer.finish()
	var score = penguinPlayer.get_time_text()
	print("Congrats your time is", score)
	get_tree().paused = true
