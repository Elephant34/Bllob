extends Sprite


var speed = 150

func _ready():
	"""
	Sets up the falling box
	"""
	
	$BllobCollision.add_to_group("boxes")
	$Area2D.add_to_group("falling_box")
	
	position = Vector2(
		randi() % int(get_viewport_rect().size.x),
		-100
	)

func _process(dt):
	"""
	Updates position
	"""
	
	position.y += speed * dt
	
	# Makes the box dissapear when no longer visible
	if position.y > get_viewport_rect().size.y+100:
		queue_free()


func _on_Area2D_area_entered(area):
	# Attempts to minimise boxes falling in the same place
	if area.is_in_group("falling_box"):
		if position.y > 0:
			position.x = randi() % int(get_viewport_rect().size.x)
