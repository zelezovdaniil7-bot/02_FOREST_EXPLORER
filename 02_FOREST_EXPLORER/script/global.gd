extends Node
signal item_collected(item_name: String)
var name_user: String = ""
var hp: int = 10
var hov: int = 6
var bag: int = 0
var wg: int = 0
var mushrooms: int = 0
func set_info(_hp, _hov, _bag, _wg, _name) -> void:
    hp = int(_hp)
    hov = int(_hov)
    bag = int(_bag)
    wg = int(_wg)
    name_user = str(_name)
func collect_mushroom() -> void:
    mushrooms += 1
    item_collected.emit("mushrooms")
