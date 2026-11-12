extends CharacterBody2D
@export var speed: float = 40.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var is_sitting := false
func _ready() -> void:
    name = "Player"
    $NameLabel.text = Global.name_user
    var texture: Texture2D = load("res://assets/player.png")
    var frames := SpriteFrames.new()
    frames.remove_animation("default")
    for state in ["idle", "walk", "sit"]:
        frames.add_animation(state)
        frames.set_animation_speed(state, 5.0 if state == "walk" else 2.0)
        frames.set_animation_loop(state, true)
    var count := {"idle": 2, "walk": 4, "sit": 2}
    for state in count.keys():
        for i in range(count[state]):
            var tex := AtlasTexture.new()
            tex.atlas = texture
            tex.region = Rect2((i if state != "sit" else i) * 16, (16 if state == "sit" else 0), 16, 16)
            frames.add_frame(state, tex)
    anim.sprite_frames = frames
    anim.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    anim.play("idle")
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("interact"):
        is_sitting = not is_sitting
        anim.play("sit" if is_sitting else "idle")
func _physics_process(_delta: float) -> void:
    if is_sitting:
        velocity = Vector2.ZERO
        move_and_slide()
        return
    var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = direction.normalized() * speed
    if direction.x > 0: anim.flip_h = true
    elif direction.x < 0: anim.flip_h = false
    if direction != Vector2.ZERO:
        if anim.animation != "walk": anim.play("walk")
    else:
        if anim.animation != "idle": anim.play("idle")
    move_and_slide()
