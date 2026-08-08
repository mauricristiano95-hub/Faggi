extends Node

@export var max_health = 3
@export var max_candles = 28
@onready var health = max_health
@onready var candles = 0

signal no_health
signal full_candles

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")

func set_candles(value):
	candles = value
	print(candles)
	if candles == max_candles:
		emit_signal("full_candles")
