class_name UnitCard
extends Button

signal unit_bought(unit: UnitStats)

const HOVER_BORDER_COLOR := Color("fafa82")

@export var player_stats: PlayerStats
@export var unit_status: UnitStats:
	set(value):
		unit_status = value
		
		if not is_node_ready():
			await ready
			
		if not unit_status:
			empty_placeholder.show()
			disabled = true
			bought = true
			return

		border_color = UnitStats.RARITY_COLORS[unit_status.rarity]
		border_sb.border_color = border_color
		bottom_sb.bg_color = border_color
		unit_name.text = unit_status.name
		gold_cost.text = str(unit_status.gold_cost)
		unit_icon.texture.region.position = Vector2(unit_status.skin_coordinates) * Arena.CELL_SIZE

@onready var traits = %Traits
@onready var bottom = %Bottom
@onready var unit_name = %UnitName
@onready var gold_cost = %GoldCost
@onready var border = %Border
@onready var unit_icon = %UnitIcon
@onready var empty_placeholder = %EmptyPlaceholder
@onready var border_sb: StyleBoxFlat = border.get_theme_stylebox("panel")
@onready var bottom_sb: StyleBoxFlat = bottom.get_theme_stylebox("panel")

var bought := false
var border_color: Color


func _ready():
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()


func _on_player_stats_changed():
	if not unit_status:
		return

	var has_enough_gold := player_stats.gold >= unit_status.gold_cost
	disabled = not has_enough_gold

	if has_enough_gold or bought:
		modulate = Color(Color.WHITE, 1.0)
	else:
		modulate = Color(Color.WHITE, 0.5)
	
	
func _on_pressed():
	if bought:
		return
	
	bought = true
	empty_placeholder.show()
	player_stats.gold -= unit_status.gold_cost
	unit_bought.emit(unit_status)


func _on_mouse_entered():
	if not disabled:
		border_sb.border_color = HOVER_BORDER_COLOR


func _on_mouse_exited():
	border_sb.border_color = border_color
