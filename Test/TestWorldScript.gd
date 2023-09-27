extends Node2D

# This is set-up to see if I can fix jitter on 60hz+ screens.
# Apparently this works good enough.


func _unhandled_key_input(event):
	if event.is_action_pressed("ui_accept"):
		#$Camera2D/CanvasLayer/Label.visible = not $Camera2D/CanvasLayer/Label.visible
		$CanvasLayer/Label.visible = not $CanvasLayer/Label.visible
