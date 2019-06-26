extends KinematicBody2D
class_name BlobNode
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var defaultTexture = preload("res://icon.png")
var force := Vector2( 0.0, 0.0 )
onready var sprite = $NodeSprite
var neighbors:Array = []
var resting_length:Array = []
var near_bodies:Array = []
var leg_bodies:Array = []
var nearest_body = null;
var last_nearest_body = null;
var velocity := Vector2( 0.0, 0.0 )
var previous_position := Vector2( 0.0, 0.0 )
var nearest_body_force = 20000.0
onready var detector = $ObjectDetectionZone
var is_central_node = false

export(bool) var is_static:bool = false setget set_static
func set_static(value):
	is_static = value

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.set_texture(defaultTexture)
	previous_position = position
	#sprite.set_texture(null)
	pass # Replace with function body.

func add_neighbor(blob_node):
	neighbors.append(blob_node)
	resting_length.append((blob_node.position - position).length())

func add_leg_blobs(legs:Array):
	for leg in legs:
		leg_bodies.append(leg)
	pass

func compute_force():
	force = Vector2()
	for i in range( neighbors.size()):
		var distance = neighbors[i].position - position
		var difference = distance.length() - resting_length[i]
		var relative_velocity = neighbors[i].velocity - velocity
		var spring_damping = relative_velocity.project(distance)
		
		# spring stiffness
		force += 0.5 * difference * distance.normalized()
		# spring damping
		force += spring_damping * 1
	
	#add gravity
	force += globals.gravity
	
	if nearest_body != null:
		pass
	for i in near_bodies:
		var my_pos = self.get_global_position()
		var other_pos = i.get_global_position()# position
		var repulsive_vec:Vector2 = (my_pos - other_pos)
		if repulsive_vec.length() != 0:
			var repulsive_strength = 1 / repulsive_vec.length()
			repulsive_strength = repulsive_strength * repulsive_strength
			if i == nearest_body:
				repulsive_strength *= 30
			force += repulsive_vec.normalized() * nearest_body_force * repulsive_strength
			#print(repulsive_strength)
		

func _draw():
	draw_line(Vector2(), velocity*10, Color.red,5)
	if (nearest_body != null):
		var my_pos = self.get_global_position()# get_parent().get_position() + position
		var other_pos = nearest_body.get_global_position()
		draw_line(Vector2(), other_pos - my_pos, Color.blueviolet, 5.0)
	
	for i in near_bodies:
		var my_pos = self.get_global_position()# get_parent().get_position() + position
		var other_pos = i.get_global_position()
		draw_line(Vector2(), other_pos - my_pos, Color.lightblue, 1.0)

func add_velocity(v):
	velocity          += v
	previous_position = position - velocity * get_physics_process_delta_time()

func add_velocity_if_possible(v):
	#if nearest_body != null:
	velocity          += v
	previous_position = position - velocity * get_physics_process_delta_time()

func set_velocity(v):
	velocity          = v
	previous_position = position - velocity * get_physics_process_delta_time()

func _process(delta):
	# Detect near bodies
	nearest_body = null
	var distance_to_nearest = 500.0
	near_bodies.clear()
	var detected_bodies = detector.get_overlapping_bodies()
	for i in detected_bodies:
		if (i.get_class() != "BlobNode"):
			near_bodies.append(i)
			var my_pos = self.get_global_position()
			var other_pos = i.get_global_position()
			var distance = my_pos.distance_to(other_pos)
			if distance < distance_to_nearest:
				distance_to_nearest = distance
				nearest_body = i
		pass
		
	if nearest_body != null:
		leg_bodies[0].position = position
		if nearest_body != last_nearest_body:
			for i in range (leg_bodies.size()):
				if i == 0:
					pass
				elif i == (leg_bodies.size() - 1):
					leg_bodies.back().position = nearest_body.get_global_position()
				else:
					leg_bodies[i].position = position + (nearest_body.get_global_position() - position) / (i + 1)
					pass
		
		last_nearest_body = nearest_body
	#if detected_bodies.size() > 1:
	#	print(detected_bodies.size())
	update()

func _physics_process( delta ):
	if !Engine.is_editor_hint() && !is_static:
		compute_force()
		verlet( delta )


func verlet( delta ):
	var new_position  = 2*position - previous_position 
	new_position     += force * pow( delta, 2.0 )
	previous_position = position
	move_and_collide(new_position - previous_position)
	
	#position          = new_position
	velocity          = (position - previous_position)/delta

func symplectic_euler(delta):
	
	pass

func    get_class(): return "BlobNode"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
