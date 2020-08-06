extends "res://Pickups/Pickup.gd"

func apply_effect(player):
	PlayerStats.health += 1
	.apply_effect(player)
