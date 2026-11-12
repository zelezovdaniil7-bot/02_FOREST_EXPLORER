extends Node2D
func _ready() -> void:
    var sprite := AnimatedSprite2D.new()
    var frames := SpriteFrames.new()
    frames.set_animation_speed("default", 5.0)
    var texture: Texture2D = load("res://assets/camp.png")
    for i in range(3):
        var frame := AtlasTexture.new()
        frame.atlas = texture
        frame.region = Rect2(i * 16, 0, 16, 16)
        frames.add_frame("default", frame)
    sprite.sprite_frames = frames
    add_child(sprite)
    sprite.play("default")
    var light := PointLight2D.new()
    light.texture = load("res://assets/light.png")
    light.texture_scale = 2.8
    light.energy = 1.3
    light.color = Color("#ffb86b")
    add_child(light)
