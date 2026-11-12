extends Node2D
@export var item_id: String = "mushrooms"
func _ready() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = load("res://assets/mushroom.png")
	add_child(sprite)
	var area := Area2D.new()
	area.collision_layer = 0
	area.collision_mask = 1
	add_child(area)
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 9.0
	shape.shape = circle
	area.add_child(shape)
	area.body_entered.connect(_on_area_2d_body_entered)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.collect_mushroom()
		queue_free()
