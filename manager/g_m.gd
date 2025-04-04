extends Node

##################################################
enum CELL_COLOR {
	RED,
	YELLOW,
	GREEN,
	BLUE
	}
# CELL_COLOR 열거형을 정의하여 모래의 색상을 나타냄
	
var sand_color: CELL_COLOR = CELL_COLOR.RED
# 현재 선택된 모래 색상을 저장하는 변수로, 기본값은 RED

##################################################
func get_sand_color() -> CELL_COLOR:
	return sand_color
# 현재 선택된 모래 색상을 반환하는 getter 함수

##################################################
func set_sand_color(color_value: CELL_COLOR) -> void:
	sand_color = color_value
# 모래 색상을 설정하는 setter 함수
