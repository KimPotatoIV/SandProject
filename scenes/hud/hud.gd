extends CanvasLayer

##################################################
var color_label_node: Label
# 색상 정보를 표시할 Label 노드를 저장할 변수

##################################################
func _ready() -> void:
	color_label_node = $ColorLabel
	# MarginContainer 내의 ColorLabel 노드를 가져와 변수에 할당

##################################################
func _process(delta: float) -> void:
	if GM.get_sand_color() == GM.CELL_COLOR.RED:
		color_label_node.text = "Red"
		color_label_node.modulate = Color(1, 0, 0)
	elif GM.get_sand_color() == GM.CELL_COLOR.YELLOW:
		color_label_node.text = "Yellow"
		color_label_node.modulate = Color(1, 1, 0)
	elif GM.get_sand_color() == GM.CELL_COLOR.GREEN:
		color_label_node.text = "Green"
		color_label_node.modulate = Color(0, 1, 0)
	elif GM.get_sand_color() == GM.CELL_COLOR.BLUE:
		color_label_node.text = "Blue"
		color_label_node.modulate = Color(0, 0, 1)
	# GM의 현재 모래 색상에 따라 Label의 텍스트와 색상을 변경
