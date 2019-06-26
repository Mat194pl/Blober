extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var ShaderDrawer = get_node("ViewportContainer/Viewport/ShaderDrawer")
onready var Blob = get_node("../Blob")
onready var RenderViewport = get_node("ViewportContainer/Viewport")
onready var ShaderViewSprite = get_node("../ShaderView/ShaderViewSprite")

# Called when the node enters the scene tree for the first time.
func _ready():
	ShaderDrawer.set_object_to_draw(Blob)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var texture = RenderViewport.get_texture()
	ShaderViewSprite.set_texture(texture)
	pass
