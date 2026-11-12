extends Control

var name_edit: TextEdit
var hp_edit: TextEdit
var hov_edit: TextEdit
var bag_edit: TextEdit
var wg_edit: TextEdit

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

    # Фон
    var bg = ColorRect.new()
    bg.color = Color("#1e2433")
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)

    var vbox = VBoxContainer.new()
    vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    vbox.add_theme_constant_override("margin_left", 6)
    vbox.add_theme_constant_override("margin_top", 6)
    vbox.add_theme_constant_override("margin_right", 6)
    vbox.add_theme_constant_override("margin_bottom", 6)
    vbox.add_theme_constant_override("separation", 2)
    add_child(vbox)

    name_edit = create_input_row(vbox, "Имя: ")
    hp_edit = create_input_row(vbox, "HP: ")
    hov_edit = create_input_row(vbox, "Hov: ")
    bag_edit = create_input_row(vbox, "Bag: ")
    wg_edit = create_input_row(vbox, "Wg: ")

    # Кнопка "Далее"
    var btn = Button.new()
    btn.text = "Далее"
    btn.add_theme_font_size_override("font_size", 10) 
    btn.add_theme_color_override("font_color", Color("#ffffff"))
    btn.custom_minimum_size = Vector2(0, 18)
    
    # Стиль кнопки
    var btn_style = StyleBoxFlat.new()
    btn_style.bg_color = Color("#4a5a7a")
    btn_style.set_corner_radius_all(4)
    
    btn.add_theme_stylebox_override("normal", btn_style)
    btn.add_theme_stylebox_override("hover", btn_style)
    btn.add_theme_stylebox_override("pressed", btn_style)
    
    btn.pressed.connect(_on_next_pressed) 
    vbox.add_child(btn)

func create_input_row(parent: Node, label_text: String) -> TextEdit:
    var hbox = HBoxContainer.new()
    parent.add_child(hbox)

    var label = Label.new()
    label.text = label_text
    label.add_theme_font_size_override("font_size", 10)
    label.add_theme_color_override("font_color", Color("#a0aabf"))
    label.custom_minimum_size = Vector2(28, 0)
    hbox.add_child(label)

    var text_edit = TextEdit.new()
    text_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    text_edit.custom_minimum_size = Vector2(100, 16) 
    text_edit.add_theme_font_size_override("font_size", 10)
    text_edit.add_theme_color_override("font_color", Color("#ffffff"))
    text_edit.wrap_mode = TextEdit.LINE_WRAPPING_NONE
    
    # Стиль поля ввода
    var edit_style = StyleBoxFlat.new()
    edit_style.bg_color = Color("#2a3448")
    edit_style.set_corner_radius_all(3)
    
    
    edit_style.border_width_left = 1
    edit_style.border_width_top = 1
    edit_style.border_width_right = 1
    edit_style.border_width_bottom = 1
    edit_style.border_color = Color("#4a5a7a")
    
    text_edit.add_theme_stylebox_override("normal", edit_style)
    text_edit.add_theme_stylebox_override("focus", edit_style) 
    
    
    text_edit.add_theme_constant_override("content_margin_top", 1)
    text_edit.add_theme_constant_override("content_margin_bottom", 1)
    text_edit.add_theme_constant_override("content_margin_left", 4)
    text_edit.add_theme_constant_override("content_margin_right", 4)
    
    hbox.add_child(text_edit)
    
    return text_edit

func _on_next_pressed() -> void:
    Global.set_info(hp_edit.text, hov_edit.text, bag_edit.text, wg_edit.text, name_edit.text)
    
    var next_scene = load("res://scenes/Ui.tscn").instantiate()
    get_tree().root.add_child(next_scene)
    get_tree().current_scene.queue_free()
    get_tree().current_scene = next_scene
