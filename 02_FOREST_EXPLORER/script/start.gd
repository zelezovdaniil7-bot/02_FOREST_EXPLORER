extends Control
var name_input: LineEdit
func _ready() -> void:
    var bg := ColorRect.new()
    bg.color = Color("#172b27")
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)
    var panel := VBoxContainer.new()
    panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
    panel.position = Vector2(97, 49)
    panel.size = Vector2(190, 118)
    panel.add_theme_constant_override("separation", 5)
    add_child(panel)
    var title := Label.new()
    title.text = "FOREST EXPLORER"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 14)
    title.add_theme_color_override("font_color", Color("#d4edb4"))
    panel.add_child(title)
    var hint := Label.new()
    hint.text = "Введите имя героя (3+ символа)"
    hint.add_theme_font_size_override("font_size", 8)
    panel.add_child(hint)
    name_input = LineEdit.new()
    name_input.placeholder_text = "Имя игрока"
    name_input.max_length = 18
    name_input.text = Global.name_user
    panel.add_child(name_input)
    var start := Button.new()
    start.text = "НАЧАТЬ ИГРУ"
    start.pressed.connect(_start)
    panel.add_child(start)
    var info := Label.new()
    info.text = "WASD: ходить   E: сесть / встать"
    info.add_theme_font_size_override("font_size", 7)
    info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    panel.add_child(info)
func _start() -> void:
    var n := name_input.text.strip_edges()
    if n.length() < 3:
        name_input.placeholder_text = "Минимум 3 символа!"
        name_input.text = ""
        return
    Global.name_user = n
    Global.mushrooms = 0
    get_tree().change_scene_to_file("res://scenes/Forest.tscn")
