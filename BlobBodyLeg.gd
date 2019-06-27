extends Node2D
class_name BlobBodyLeg
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var neighbors:Array = []
var resting_length:Array = []

func add_neighbor(blob_node):
	neighbors.append(blob_node)
	resting_length.append((blob_node.position - position).length())

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
