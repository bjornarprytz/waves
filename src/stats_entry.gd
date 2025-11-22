class_name StatsEntry
extends HBoxContainer

@onready var header_label: RichTextLabel = $Header
@onready var value_label: RichTextLabel = $Value

func set_it(header: String, value: Variant):
	header_label.text = header
	value_label.text = str(value)
