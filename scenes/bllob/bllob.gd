extends AnimatedSprite


var global

var is_setup = false

var id
var mode

var self_data

var panel_visible = false

var appetite_count = 5
var satisfaction_count = 5

var aging_count = 20


func _ready():
	"""
	Called when bllob is added to scene
	"""
	
	# Checks the bllob is correctly set up
	if not is_setup:
		print("WARNING- bllob not setup, call setup function before adding child")
		return
	
	global = get_tree().get_current_scene()
	
	# Save typing time
	self_data = global.bllob_data[id]
	
	# Sets all the bllob attritubes from save
	set_dynamics()
	set_colour()
	set_pos()
	
	# Sets the timers
	$Appetite.wait_time = appetite_count * self_data["appetite"]
	$Satisfaction.wait_time = satisfaction_count * self_data["satisfaction"]
	$Aging.wait_time = aging_count


func _process(_dt):
	if panel_visible:
		set_attribute_text()


func setup(bllob_id, bllob_mode):
	"""
	Called after instancing a bllob but before adding it to the scene
	"""
	
	id = bllob_id
	mode = bllob_mode
	
	is_setup = true

func set_dynamics():
	"""
	Sets the correct animation for the bllobs age and mode
	"""
	
	match mode:
		"home":
			# Idle home animation
			if self_data.age >= 0:
				animation = "adult"
				frame = randi() % frames.get_frame_count(animation)
				playing = true

func set_colour():
	"""
	Sets the modulation to change bllob colour
	"""
	
	modulate = Color(
		self_data.colour[0],
		self_data.colour[1],
		self_data.colour[2]
	)

func set_pos():
	"""
	Sets the bllobs home position
	"""
	
	match mode:
		"home":
			position = Vector2(
				self_data.position[0],
				self_data.position[1]
			)


func set_attribute_text():
	"""
	Sets all the text for bllob panel
	"""
	var attribute_list = $BllobPanel/MarginContainer/AttributeList
	
	attribute_list.get_node("Name").text = id
	attribute_list.get_node("Age").text = "Age: %s" % self_data.age
	attribute_list.get_node("Health").text = "Health: %s" % self_data.health
	attribute_list.get_node("Hunger").text = "Hunger: %s" % self_data.hunger
	attribute_list.get_node("Happiness").text = "Happiness: %s" % self_data.happiness
	attribute_list.get_node("Strength").text = "Strength: %s" % self_data.strength
	attribute_list.get_node("Agility").text = "Agility: %s" % self_data.agility
	attribute_list.get_node("Stamina").text = "Stamina: %s" % self_data.stamina


func _on_BllobPanel_about_to_show():
	$BllobPanel/Tween.interpolate_property($BllobPanel, "modulate:a", 0.0, 1.0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	$BllobPanel.rect_position = Vector2(
		self_data.position[0]+50,
		self_data.position[1]-144
	)
	
	set_attribute_text()
	
	$BllobPanel/Tween.start()


func _on_BllobShape_mouse_entered():
	$BllobPanel.popup()
	panel_visible = true


func _on_BllobShape_mouse_exited():
	$BllobPanel.hide()
	panel_visible = false


func _on_Timer_timeout(timer):
	"""
	Called when a timer timesout to change an attribute
	"""
	match timer:
		"appetite":
			self_data.hunger -= 1
		"satisfaction":
			self_data.happiness -= 1
		"aging":
			self_data.age += 1
			set_dynamics()
