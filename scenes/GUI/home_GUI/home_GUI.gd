extends Control


var global

var last_menu_open


func _ready():
	global = get_tree().get_current_scene()
	
	$Node/MenuPanel.visible = false


func _process(_dt):
	# Updates coin counter
	$Node/Coins.text = "Coins: %s" % global.coins
	
	# Updates time counter
	$Node/Time.text = "Time: %s" % global.get_readable_time()


func _on_MenuPanel_event(button):
	"""
	Called to open or close the menu panel of the relevant button
	"""
	
	if last_menu_open == button:
		button = "exit"
	
	$Node/MenuPanel.visible = true
	
	$Node/MenuPanel/GamesPanel.visible = false
	$Node/MenuPanel/ShopPanel.visible = false
	$Node/MenuPanel/BreedingPanel.visible = false
	$Node/MenuPanel/HatcheryPanel.visible = false
	
	match button:
		"games":
			$Node/MenuPanel/GamesPanel.visible = true
		"shop":
			$Node/MenuPanel/ShopPanel.visible = true
		"breeding":
			$Node/MenuPanel/BreedingPanel.visible = true
		"hatchery":
			$Node/MenuPanel/HatcheryPanel.visible = true
		"exit":
			$Node/MenuPanel.visible = false
	
	last_menu_open = button
