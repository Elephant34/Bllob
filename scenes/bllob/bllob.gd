extends Node2D


func _ready():
	# Link to buttons to their event
	$GUI/Node/Games.connect("pressed", self, "_on_GamesBtn_pressed")
	$GUI/Node/Shop.connect("pressed", self, "_on_ShopBtn_pressed")
	$GUI/Node/Breeding.connect("pressed", self, "_on_BreedingBtn_pressed")
	$GUI/Node/Hatchery.connect("pressed", self, "_on_HatcheryBtn_pressed")

func _on_GamesBtn_pressed():
	print("hello world- G")

func _on_ShopBtn_pressed():
	print("hello world- S")

func _on_BreedingBtn_pressed():
	print("hello world- B")

func _on_HatcheryBtn_pressed():
	print("hello world- H")
