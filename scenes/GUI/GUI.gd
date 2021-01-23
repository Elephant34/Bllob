extends Control

# Stores the last button press to hide/show the menu_panel
var last_pressed

func _ready():
	# Hide all panel elements just in case I forget to hide them manually
	menu_panel_button_pressed()
	hide_bllob_panel()

func _input(event):
	# Close the panel if esc is pressed
	if event.is_action_pressed("ui_cancel"):
		menu_panel_button_pressed()
		hide_bllob_panel()

func menu_panel_button_pressed(button=null):
	"""
	Called when a button which should trigger the panel is pressed
	Accepted buttons- games, shop, breeding, hatchery
	"""
	hide_bllob_panel()
	hide_menu_panel()
	
	if last_pressed == button or not button:
		button = null
	else:
		$Node/MenuPanel.visible = true
		match button:
			"games":
				$Node/MenuPanel/GamesPanel.visible = true
			"shop":
				$Node/MenuPanel/ShopPanel.visible = true
			"breeding":
				$Node/MenuPanel/BreedingPanel.visible = true
			"hatchery":
				$Node/MenuPanel/HatcheryPanel.visible = true
	
	last_pressed=button

func hide_menu_panel():
	"""
	Hides the panel's children and if panel is true itself as well
	"""
	$Node/MenuPanel.visible = false
	$Node/MenuPanel/GamesPanel.visible = false
	$Node/MenuPanel/ShopPanel.visible = false
	$Node/MenuPanel/BreedingPanel.visible = false
	$Node/MenuPanel/HatcheryPanel.visible = false

func show_bllob_panel(bllob_data):
	"""
	Shows the bllob data
	"""
	# Hides any other open GUI panels
	hide_menu_panel()

	# Makes the panel visible
	$Node/BllobPanel.visible = true
	
	# Sets all labels to show correct values
	$Node/BllobPanel/Health.text = "Health: %s" % bllob_data["health"]
	$Node/BllobPanel/Hunger.text = "Hunger: %s" % bllob_data["hunger"]
	$Node/BllobPanel/Happiness.text = "Happiness: %s" % bllob_data["happiness"]
	$Node/BllobPanel/Age.text = "Age: %s" % bllob_data["age"]
	$Node/BllobPanel/Strength.text = "Strength: %s" % bllob_data["strength"]
	$Node/BllobPanel/Agility.text = "Agility: %s" % bllob_data["agility"]
	$Node/BllobPanel/Staminer.text = "Staminer: %s" % bllob_data["staminer"]


func hide_bllob_panel():
	$Node/BllobPanel.visible = false
