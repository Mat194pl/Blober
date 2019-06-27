extends Node2D
class_name BlobBody

var link_object  := load("res://spring.tscn") as PackedScene
var node_object  := load("res://BlobBodyNode.tscn") as PackedScene
var leg_object := load("res://BlobBodyLeg.tscn") as PackedScene
var is_left = false;
var is_right = false;
var is_up = false;
var is_down = false;

var blob_center = null
var blobs:Array = []

func _ready():
	generate_blob_body(Vector2(200, 100))

func add_spring( node_1, node_2 ):
	var link = link_object.instance()
	link.initialize( node_1, node_2 )
	$"springs".add_child( link )

func generate_blob_body( body_position:Vector2):
	var center_point = node_object.instance()
	blob_center = center_point
	center_point.position = body_position
	var nodes_count = 6
	var leg_nodes_count = 6
	var radius = 50
	
	#center_point.is_static = true
	var central_node_leg:Array = []
	for j in range(leg_nodes_count):
		var new_leg = leg_object.instance()
		
		central_node_leg.append(new_leg)
		#if j > 0:
		#	add_spring(central_node_leg[j], central_node_leg[j - 1])
	center_point.add_leg_blobs(central_node_leg)
	add_child(center_point)
	blobs.append(center_point)
	
	for j in range(leg_nodes_count):
		add_child(central_node_leg[j])
	
	if nodes_count == 0:
		return
	
	var degress_per_node = (2 * PI) / nodes_count
	var previous_point = null
	var first_point = null
	for i in range(nodes_count):
		
		var new_point = node_object.instance()
		var new_leg:Array = []
		for j in range(leg_nodes_count):
			new_leg.append(leg_object.instance())
		new_point.add_leg_blobs(new_leg)
		blobs.append(new_point)
		if i == 0:
			first_point = new_point
		new_point.position = Vector2(sin(i * degress_per_node), cos(i * degress_per_node)) * radius + body_position
		add_child(new_point)
		for j in range(leg_nodes_count):
			add_child(new_leg[j])
		add_spring(new_point, center_point)
		if previous_point != null:
			add_spring(new_point, previous_point)
		previous_point = new_point
	add_spring(first_point, previous_point)
		
func _physics_process(delta):
	if is_left:
		blobs_add_velocity(Vector2(-100.0, -10) * delta)
	if is_right:
		blobs_add_velocity(Vector2(100.0, -10) * delta)
	if is_up:
		blobs_add_velocity(Vector2(0.0, -100.0) * delta)
	if is_down:
		blobs_add_velocity(Vector2(0.0, 100.0) * delta)
	pass
	

func blobs_add_velocity(v):
	for i in blobs:
		i.add_velocity_if_possible(v)

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("left"):
			is_left = true;
		if event.is_action_released("left"):
			is_left = false
		if event.is_action_pressed("right"):
			is_right = true;
		if event.is_action_released("right"):
			is_right = false;
		if event.is_action_pressed("up"):
			is_up = true;
		if event.is_action_released("up"):
			is_up = false;
		if event.is_action_pressed("down"):
			is_down = true;
		if event.is_action_released("down"):
			is_down = false;

func _draw():
	pass