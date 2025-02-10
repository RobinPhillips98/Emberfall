extends Control

func _ready():
	await $Victory.playing == false
	Global.next_level()
