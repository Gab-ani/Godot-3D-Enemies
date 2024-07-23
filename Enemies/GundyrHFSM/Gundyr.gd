extends CharacterBody3D


@export var player : CharacterBody3D
@onready var state_machine = $GundyrHFSM as HFSM


func _ready():
	state_machine.player = player
	state_machine._on_enter()
	state_machine._accept_export_fields()


func _physics_process(delta):
	state_machine._update(delta)
