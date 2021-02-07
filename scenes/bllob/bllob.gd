extends AnimatedSprite


var global

var is_setup = false

var id
var mode

var self_data


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
	
	set_dynamics()
	set_colour()
	set_pos()
	

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
