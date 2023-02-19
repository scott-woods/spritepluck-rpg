class_name EnemyMoving
extends EnemyCombat


@onready var navigation_timer : Timer = $NavigationTimer

#override this with custom movement for different enemy types
func update(delta):
	super(delta)
