extends CanvasLayer

func _on_shoot_pressed() -> void:
	$Shoot.modulate.a = 0.5


func _on_shoot_released() -> void:
	$Shoot.modulate.a = 1
	
	
func _on_pass_pressed() -> void:
	$Pass.modulate.a = 0.5


func _on_pass_released() -> void:
	$Pass.modulate.a = 1
