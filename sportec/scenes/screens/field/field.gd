class_name FieldScreen
extends Screen

@onready var pause_button: TextureButton = $HUD/PauseButton
@onready var pause_menu = $HUD/PauseMenu

func _ready() -> void:
	if pause_button:
		if not pause_button.pressed.is_connected(pauseButtonPressed):
			pause_button.pressed.connect(pauseButtonPressed)

func pauseButtonPressed() -> void:
	
	pause_button.modulate.a = 0.5
	await get_tree().create_timer(0.1).timeout
	pause_button.modulate.a = 1.0
	
	if pause_menu:
		pause_menu.togglePause() 
		
		pause_button.visible = false

func showPauseButton() -> void:
	if pause_button:
		pause_button.visible = true
