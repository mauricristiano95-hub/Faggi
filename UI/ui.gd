extends Control

var DEFAULT_DEATH_TEXT = "You are too scared..."

func set_health(value):
	$Health.text = "Health: " + str(value)

func set_candles(value):
	$Candles.text = "Candles: " + str(value)

func set_dead_text(value):
	$DeathScreen/Label.text = value

func set_dead_msg():
	$DeathScreen.visible = true
	var tween = create_tween()
	tween.tween_property($DeathScreen, "modulate:a", 1, 1.0).set_trans(Tween.TRANS_CUBIC)
	
func set_pause():
	$PauseScreen.visible = !($PauseScreen.visible)

func _ready() -> void:
	set_health(PlayerStats.health)
	set_candles(PlayerStats.candles)
	$DeathScreen.visible = false
	$PauseScreen.visible = false
	$DeathScreen.modulate = Color(1.0, 1.0, 1.0, 0.0)
	PlayerStats.connect("player_health_changed", set_health)
	PlayerStats.connect("player_candle_changed", set_candles)
	PlayerStats.connect("no_health", set_dead_msg)
	PlayerStats.connect("death_text", set_dead_text)
	PlayerStats.connect("pause", set_pause)

func _on_retry_pressed() -> void:
	PlayerStats.retry_level()
	var tween = create_tween()
	tween.tween_property($DeathScreen, "modulate:a", 0, 1.0).set_trans(Tween.TRANS_CUBIC)
	$DeathScreen.visible = false
	set_dead_text(DEFAULT_DEATH_TEXT)

func _on_quit_pressed() -> void:
	get_tree().quit()
