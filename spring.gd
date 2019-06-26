tool
extends Node2D
class_name SpringNode

export(NodePath) var node_path_1:NodePath setget set_node_1
export(NodePath) var node_path_2:NodePath setget set_node_2

var from:BlobNode
var to:BlobNode

func set_node_1(value:NodePath):
	node_path_1 = value
	if Engine.is_editor_hint() and has_node(value):
		from = get_node(value) as BlobNode
	
func set_node_2(value:NodePath):
	node_path_2 = value
	if Engine.is_editor_hint() and has_node(value):
		to = get_node(value) as BlobNode
	
func initialize( node_1:BlobNode, node_2:BlobNode ):
	from = node_1
	to   = node_2
	
func _ready():
#	if !Engine.is_editor_hint():
	if !from:
		from = get_node(node_path_1) as BlobNode
	if !to:
		to = get_node(node_path_2) as BlobNode
	from.add_neighbor(to)
	to.add_neighbor(from)
		
func _draw():
	draw_line(from.position, to.position, Color.blue, 4.0)
	pass
		
func _process( _delta ):
	update()
	if from and to :
		position            = 0.5 * ( from.position + to.position )
		
		var relation_vector := from.position - to.position
		rotation            = atan2( relation_vector.x, -relation_vector.y )
		scale.y             = relation_vector.length() / 128.0
		scale.x             = 32.0 / max( relation_vector.length() , 32.0 )