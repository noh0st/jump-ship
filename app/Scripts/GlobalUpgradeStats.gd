tool
extends Node

var globalSelfHealth: float = 100 #health of boids and player
var boidDamage: float = 20
var playerStamina: float = 100
var globalEnemyHealth: float = 100 # health of all enemies
var globalEnemyDamage: float = 20

func GlobalReset():
	globalSelfHealth = 100 #health of boids and player
	boidDamage = 20
	playerStamina= 100
	globalEnemyHealth= 100 # health of all enemies
	globalEnemyDamage = 20
