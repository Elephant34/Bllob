extends Control

# Stores the last button press to hide/show the menu_panel
var last_pressed

func _ready():
	# Hide all panel elements just in case I forget to hide them manually
	hide_menu_panel(true)
	$Node/BllobPanel.visible = false

func _input(event):
	# Close the panel if esc is pressed
	if event.is_action_pressed("ui_cancel"):
		hide_menu_panel(true)
		last_pressed = null

func menu_panel_button_pressed(button):
	"""
	Called when a button which should trigger the panel is pressed
	Accepted buttons- games, shop, breeding, hatchery
	"""
	if last_pressed == button:
		hide_menu_panel(true)
		button = null
	else:
		hide_menu_panel()
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

func hide_menu_panel(panel=false):
	"""
	Hides the panel's children and if panel is true itself as well
	"""
	if panel:
		$Node/MenuPanel.visible = false
	$Node/MenuPanel/GamesPanel.visible = false
	$Node/MenuPanel/ShopPanel.visible = false
	$Node/MenuPanel/BreedingPanel.visible = false
	$Node/MenuPanel/HatcheryPanel.visible = false
