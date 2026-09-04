extends Control

var DEFAULT_DEATH_TEXT = "You are too scared..."
@onready var life_heart_max_size = $life_heart.size

func set_health(value):
	$life_heart.size.x = (value / PlayerStats.max_health)*life_heart_max_size.x

func set_candles(value):
	$Candles.text = "x" + str(value) + "/" + str(PlayerStats.max_candles)

func set_dead_text(value):
	$DeathScreen/Label.text = value

func set_dead_msg():
	$DeathScreen.visible = true
	var tween = create_tween()
	tween.tween_property($DeathScreen, "modulate:a", 1, 1.0).set_trans(Tween.TRANS_CUBIC)
	
func set_pause():
	$PauseScreen.visible = !($PauseScreen.visible)

func set_level_complete():
	var tween = create_tween()
	tween.tween_property($Fade, "modulate:a", 1, 1.0).set_trans(Tween.TRANS_CUBIC)
	
func set_level_start():
	var tween = create_tween()
	tween.tween_property($Fade, "modulate:a", 0, 1.0).set_trans(Tween.TRANS_CUBIC)

func _ready() -> void:
	$DeathScreen.visible = false
	$PauseScreen.visible = false
	$Fade.visible = true
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
