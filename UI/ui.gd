extends Control

func set_health(value):
	$Health.text = "Health: " + str(value)

func set_candles(value):
	$Candles.text = "Candles: " + str(value)

func set_dead_msg():
	$Death.visible = true

func _ready() -> void:
	set_health(PlayerStats.health)
	set_candles(PlayerStats.candles)
	$Death.visible = false
	PlayerStats.connect("player_health_changed", set_health)
	PlayerStats.connect("player_candle_changed", set_candles)
	PlayerStats.connect("no_health", set_dead_msg)
	
