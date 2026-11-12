extends Control

var name_label: Label
var lv_label: Label
var hp_label: Label
var hov_label: Label
var bag_label: Label
var wg_label: Label
var time_label: Label
var hearts_container: HBoxContainer
var avatar: TextureRect

var heart_icon = preload("res://assets/heart.png") 
var timer: Timer

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

    # 1. Красивый фон с закругленными углами и рамкой
    var bg = Panel.new()
    var panel_style = StyleBoxFlat.new()
    panel_style.bg_color = Color("#1e2433") # Глубокий темно-синий
    panel_style.set_corner_radius_all(8)
    
    # ИСПРАВЛЕНО: Рамка задается для каждой стороны отдельно
    panel_style.border_width_left = 2
    panel_style.border_width_top = 2
    panel_style.border_width_right = 2
    panel_style.border_width_bottom = 2
    panel_style.border_color = Color("#4a5a7a") 
    
    bg.add_theme_stylebox_override("panel", panel_style)
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)

    # 2. Главный контейнер
    var vbox = VBoxContainer.new()
    vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    vbox.add_theme_constant_override("margin_left", 10)
    vbox.add_theme_constant_override("margin_top", 10)
    vbox.add_theme_constant_override("margin_right", 10)
    vbox.add_theme_constant_override("margin_bottom", 10)
    vbox.add_theme_constant_override("separation", 8)
    add_child(vbox)

    # 3. Верхняя часть (Аватарка + Имя + Сердечки + Уровень)
    var user_hbox = HBoxContainer.new()
    user_hbox.add_theme_constant_override("separation", 8)
    vbox.add_child(user_hbox)

    # Красивая плашка под аватарку
    var avatar_panel = PanelContainer.new()
    var av_style = StyleBoxFlat.new()
    av_style.bg_color = Color("#2a3448")
    av_style.set_corner_radius_all(6)
    avatar_panel.add_theme_stylebox_override("panel", av_style)
    user_hbox.add_child(avatar_panel)

    avatar = TextureRect.new()
    avatar.texture = load("res://icon.png")
    avatar.custom_minimum_size = Vector2(48, 48)
    avatar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    avatar.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    avatar_panel.add_child(avatar)

    # Блок с именем и сердечками
    var user_vbox = VBoxContainer.new()
    user_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    user_vbox.add_theme_constant_override("separation", 2)
    user_hbox.add_child(user_vbox)

    name_label = Label.new()
    name_label.add_theme_font_size_override("font_size", 14)
    name_label.add_theme_color_override("font_color", Color("#ffffff"))
    user_vbox.add_child(name_label)

    hearts_container = HBoxContainer.new()
    hearts_container.add_theme_constant_override("separation", 2)
    user_vbox.add_child(hearts_container)

    var lv_hbox = HBoxContainer.new()
    user_vbox.add_child(lv_hbox)
    var lv_text = Label.new()
    lv_text.text = "LV: "
    lv_text.add_theme_font_size_override("font_size", 10)
    lv_text.add_theme_color_override("font_color", Color("#a0aabf"))
    lv_hbox.add_child(lv_text)
    lv_label = Label.new()
    lv_label.add_theme_font_size_override("font_size", 10)
    lv_label.add_theme_color_override("font_color", Color("#ffd700"))
    lv_hbox.add_child(lv_label)

    # 4. Статистика
    var stats_hbox = HBoxContainer.new()
    stats_hbox.add_theme_constant_override("separation", 8)
    vbox.add_child(stats_hbox)

    hp_label = create_stat(stats_hbox, "HP: ")
    hov_label = create_stat(stats_hbox, "Hov: ")
    bag_label = create_stat(stats_hbox, "Bag: ")
    wg_label = create_stat(stats_hbox, "Wg: ")
    
    var spacer = Control.new()
    spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    stats_hbox.add_child(spacer)
    time_label = create_stat(stats_hbox, "00:00")

    # 5. Таймер
    timer = Timer.new()
    timer.wait_time = 1.0
    timer.autostart = true
    timer.timeout.connect(update_time)
    add_child(timer)

    # 6. Запускаем данные
    update_info()
    update_hearts(int(Global.hp))
    update_time()

func create_stat(parent: Node, text: String) -> Label:
    var lbl = Label.new()
    lbl.text = text
    lbl.add_theme_font_size_override("font_size", 10)
    lbl.add_theme_color_override("font_color", Color("#ced6e0"))
    parent.add_child(lbl)
    return lbl

func update_info() -> void:
    if int(Global.hp) > 9 and int(Global.hov) > 5:
        lv_label.text = "5"
    else:
        lv_label.text = "1"
        
    name_label.text = str(Global.name_user)
    hp_label.text = "HP: " + str(Global.hp)
    hov_label.text = "Hov: " + str(Global.hov)
    bag_label.text = "Bag: " + str(Global.bag)
    wg_label.text = "Wg: " + str(Global.wg)

func update_hearts(hp_value: int) -> void:
    for child in hearts_container.get_children():
        child.queue_free()
        
    var count = floor(hp_value / 2.0)
    for i in range(count):
        var rect = TextureRect.new()
        rect.texture = heart_icon
        rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
        rect.custom_minimum_size = Vector2(14, 14)
        hearts_container.add_child(rect)

func update_time() -> void:
    var t = Time.get_time_dict_from_system()
    time_label.text = '%02d:%02d' % [t.minute, t.second]
