extends Node2D
const PLAYER = preload("res://scenes/Player.tscn")
const CAMP = preload("res://scenes/Camp.tscn")
const MUSHROOM = preload("res://scenes/Mushrooms.tscn")
const UI = preload("res://scenes/UiForest.tscn")
const WIDTH := 38
const HEIGHT := 28
const TILE := 16
var ground: TileMapLayer
var plants: TileMapLayer
var walls: TileMapLayer
func _ready() -> void:
	var tile_set := TileSet.new()
	tile_set.tile_size = Vector2i(TILE, TILE)
	var atlas := TileSetAtlasSource.new()
	atlas.texture = load("res://assets/tilesets/forest_tiles.png")
	atlas.texture_region_size = Vector2i(TILE, TILE)
	for y in range(4):
		for x in range(4): atlas.create_tile(Vector2i(x, y))
	tile_set.add_source(atlas, 0)
	ground = _make_layer("Ground", tile_set, -10)
	plants = _make_layer("Plants", tile_set, 1)
	walls = _make_layer("Walls", tile_set, 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = 2402
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var edge := x < 2 or y < 2 or x >= WIDTH-2 or y >= HEIGHT-2
			var path: bool = (abs(x - 18) < 3 and y > 4 and y < 25) or (abs(y - 14) < 2 and x > 4 and x < 34)
			var ground_id := Vector2i(3,0) if path else Vector2i(rng.randi_range(0,2),0)
			ground.set_cell(Vector2i(x,y), 0, ground_id)
			if edge:
				walls.set_cell(Vector2i(x,y),0,Vector2i(1,1))
			elif not path and rng.randf() < 0.13 and Vector2(x,y).distance_to(Vector2(18,14)) > 6:
				plants.set_cell(Vector2i(x,y),0,Vector2i(rng.randi_range(1,3),1))
	# Static collision boundaries keep the character inside the forest.
	for rect in [Rect2(-16,-16,WIDTH*TILE+32,16), Rect2(-16,HEIGHT*TILE,WIDTH*TILE+32,16), Rect2(-16,0,16,HEIGHT*TILE), Rect2(WIDTH*TILE,0,16,HEIGHT*TILE)]:
		var wall_body := StaticBody2D.new()
		wall_body.collision_layer = 2
		wall_body.collision_mask = 0
		var wall_shape := CollisionShape2D.new()
		var wall_rect := RectangleShape2D.new()
		wall_rect.size = rect.size
		wall_shape.shape = wall_rect
		wall_shape.position = rect.position + rect.size / 2.0
		wall_body.add_child(wall_shape)
		add_child(wall_body)
	var player := PLAYER.instantiate()
	player.position = Vector2(18*TILE,14*TILE)
	add_child(player)
	for p in [Vector2(12,9),Vector2(25,18)]:
		var camp := CAMP.instantiate()
		camp.position = p*TILE
		add_child(camp)
	for p in [Vector2(7,6),Vector2(13,18),Vector2(26,7),Vector2(30,20),Vector2(8,22),Vector2(22,23),Vector2(31,11)]:
		var m := MUSHROOM.instantiate()
		m.position = p*TILE
		add_child(m)
	add_child(UI.instantiate())
	var overlay := CanvasModulate.new()
	overlay.color = Color("#52617e")
	add_child(overlay)
	var exit := Area2D.new()
	exit.position = Vector2(33*TILE,14*TILE)
	exit.collision_mask = 1
	exit.collision_layer = 0
	add_child(exit)
	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(20,42)
	shape.shape = rectangle
	exit.add_child(shape)
	exit.body_entered.connect(_exit_entered)
	var marker := Label.new()
	marker.text = ">>"
	marker.position = Vector2(33*TILE,12*TILE)
	add_child(marker)
func _make_layer(layer_name: String, tile_set: TileSet, order: int) -> TileMapLayer:
	var layer := TileMapLayer.new()
	layer.name = layer_name
	layer.tile_set = tile_set
	layer.z_index = order
	add_child(layer)
	return layer
func _exit_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().call_deferred("change_scene_to_file", "res://scenes/Clearing.tscn")
