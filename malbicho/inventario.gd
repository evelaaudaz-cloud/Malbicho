extends CanvasLayer

@onready var rejilla = $PanelContainer/MarginContainer/GridContainer

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("inventario"):
		toggle_inventario()

func toggle_inventario():
	visible = !visible 
	
