class_name StatsEntry
extends Control

@onready var header_label: RichTextLabel = %Header
@onready var value_label: RichTextLabel = %Value
@onready var background: ColorRect = %Background

func set_it(header: String, value: Variant, color: Color):
	header_label.text = header
	value_label.text = str(value)
	background.color = color
