extends CanvasLayer
var item_count: int = 0
var label: Label
func _ready() -> void:
    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
    margin.add_theme_constant_override("margin_left", 6)
    margin.add_theme_constant_override("margin_top", 5)
    add_child(margin)
    var row := HBoxContainer.new()
    margin.add_child(row)
    var icon := TextureRect.new()
    icon.texture = load("res://assets/mushroom.png")
    icon.custom_minimum_size = Vector2(16, 16)
    row.add_child(icon)
    label = Label.new()
    item_count = Global.mushrooms
    label.text = str(item_count)
    label.add_theme_font_size_override("font_size", 11)
    row.add_child(label)
    Global.item_collected.connect(_on_item_collected)
func _on_item_collected(item_name: String) -> void:
    if item_name == "mushrooms":
        item_count += 1
        label.text = str(item_count)
