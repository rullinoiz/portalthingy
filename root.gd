class_name GameController extends Node

@export var world3d: GameWorld3D
@export var world2d: Node2D
@export var gui: Control

func _ready() -> void:
	Global.game_controller = self
	Global.world3d = world3d
	Global.world2d = world2d
	Global.gui = gui

func _process(delta: float) -> void:
	pass
