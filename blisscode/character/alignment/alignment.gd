class_name Alignment extends Node2D

@export var character: CharacterController
@export var label: Label

var parent

func _ready() -> void:
	call_deferred("_after_ready")
	
func _after_ready():
	if not character:
		return
	character.character.character_sheet.alignment_changed.connect(_on_alignment_changed)
	refresh_ui()

func _on_alignment_changed(_alignment: float) -> void:
	if not character:
		return
	refresh_ui()
	
func refresh_ui():
	var heat = character.character.character_sheet.get_heat()
	if (heat > 0):
		var heat_stars = character.character.character_sheet.get_heat_stars()
		label.text = heat_stars
		label.show()
	else:
		label.hide()
