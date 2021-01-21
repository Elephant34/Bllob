extends Control

# Stores the last button press to hide/show the panel
var last_pressed

func _ready():
	# Hide all panel elements just in case I forget to hide them manually
	hide_panel(true)

func _input(event):
	# Close the panel if esc is pressed
	if event.is_action_pressed("ui_cancel"):
		hide_panel(true)
		last_pressed = null

func panel_button_pressed(button):
	"""
	Called when a button which should trigger the panel is pressed
	Accepted buttons- games, shop, breeding, hatchery
	"""
	if last_pressed == button:
		hide_panel(true)
		button = null
	else:
		hide_panel()
		$Node/Panel.visible = true
		match button:
			"games":
				$Node/Panel/GamesPanel.visible = true
			"shop":
				$Node/Panel/ShopPanel.visible = true
			"breeding":
				$Node/Panel/BreedingPanel.visible = true
			"hatchery":
				$Node/Panel/HatcheryPanel.visible = true
	
	last_pressed=button

func hide_panel(panel=false):
	"""
	Hides the panel's children and if panel is true itself as well
	"""
	if panel:
		$Node/Panel.visible = false
	$Node/Panel/GamesPanel.visible = false
	$Node/Panel/ShopPanel.visible = false
	$Node/Panel/BreedingPanel.visible = false
	$Node/Panel/HatcheryPanel.visible = false
