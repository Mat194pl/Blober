extends Node2D

var ObjectToDraw : Array = [];
var SpritesToDraw : Dictionary = {};

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _update():
	pass
	
func set_object_to_draw(obj_to_draw):
	ObjectToDraw.clear()
	# Get list of object's sprites (get references to them)
	var obj_children = obj_to_draw.get_children()
	for child in obj_children:
		var is_drawable = false
		# Check if child object has child sprite
		var child_class = child.get_class()
		#if child_class != "BlobNode" and child_class != "BlobBodyLeg":
		#	continue
		for child_children in child.get_children():
			if child_children.get_class() == "Sprite":
				is_drawable = true
				break
		if is_drawable:
			ObjectToDraw.append(child)
			pass
	
	# For each found sprite, create a copy of it in the local viewport
	for object in ObjectToDraw:
		for child in object.get_children():
			if child.get_class() == "Sprite":
				# Copy sprite
				SpritesToDraw[object] = child.duplicate()
				add_child(SpritesToDraw[object])
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	for object in ObjectToDraw:
		SpritesToDraw[object].position = object.position
	pass
