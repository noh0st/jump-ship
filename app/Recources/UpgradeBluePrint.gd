extends Resource

class_name Upgrades

export var UpgradeName : String = ""
export var UpgradeDescription : String = ""
export var AddedHealthToBoidsAndPlayer : float
export var AddedStaminaToPlayer : float
export var AddedDamageToBoids : float
export var AddedHealthToEnemies : float
export  var AddedDamageToEnemies : float

func Upgrade():
	GlobalUpgradeStats.globalSelfHealth += AddedHealthToBoidsAndPlayer
	GlobalUpgradeStats.playerStamina += AddedStaminaToPlayer
	GlobalUpgradeStats.boidDamage += AddedDamageToBoids
	GlobalUpgradeStats.globalEnemyHealth += AddedHealthToEnemies
	GlobalUpgradeStats.globalEnemyDamage += AddedDamageToEnemies
	PlayerStats.UpgradedValues()
