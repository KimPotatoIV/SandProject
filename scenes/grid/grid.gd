extends Node2D

##################################################
enum CELL_TYPE {
	EMPTY,
	SAND,
	SOLID
	}
# 셀 타입을 열거형으로 정의

const REF_SIZE: int = 10
const GRID_SIZE = Vector2i(1920 / REF_SIZE, 1080 / REF_SIZE)
const PIXEL_SIZE = 1 * REF_SIZE
# 그리드 크기 및 픽셀 설정
# PIXEL_SIZE는 모래 한 알의 크기

var grid: Array = []
# 그리드 저장소

##################################################
func _ready() -> void:
	for x in range(GRID_SIZE.x):
		grid.append([])
		for y in range(GRID_SIZE.y):
			grid[x].append({"type": CELL_TYPE.EMPTY, "color": null})
	# 빈 그리드 배열(CELL_TYPE.EMPTY)을 생성

##################################################
func _process(delta: float) -> void:
	for x in range(GRID_SIZE.x):
		for y in range(GRID_SIZE.y - 1, -1, -1):
			if grid[x][y]["type"] == CELL_TYPE.SAND:
				flow_sand(x, y)
	# 모래의 낙하를 처리 하며 아래에서 위로 검사하여 모래가 아래로 흐를 수 있도록 함
	
	input_left_mouse()
	input_accept()
	# 입력 처리 함수 호출
	
	queue_redraw()
	# 화면 다시 그리기

##################################################
func flow_sand(x_value: int, y_value: int) -> void:
	if y_value + 1 < GRID_SIZE.y and \
		grid[x_value][y_value + 1]["type"] == CELL_TYPE.EMPTY:
	# 바로 아래 칸이 비어있으면
		grid[x_value][y_value + 1] = grid[x_value][y_value]
		grid[x_value][y_value] = {"type": CELL_TYPE.EMPTY, "color": null}
		# 모래가 아래 칸으로 이동
	elif x_value > 0 and y_value + 1 < GRID_SIZE.y and \
		grid[x_value - 1][y_value + 1]["type"] == CELL_TYPE.EMPTY:
	# 왼쪽 대각선 아래 칸이 비어있으면
		grid[x_value - 1][y_value + 1] = grid[x_value][y_value]
		grid[x_value][y_value] = {"type": CELL_TYPE.EMPTY, "color": null}
		# 모래가 왼쪽 대각선 아래로 이동
	elif x_value + 1 < GRID_SIZE.x and y_value + 1 < GRID_SIZE.y and \
		grid[x_value + 1][y_value + 1]["type"] == CELL_TYPE.EMPTY:
	# 오른쪽 대각선 아래 칸이 비어있으면
		grid[x_value + 1][y_value + 1] = grid[x_value][y_value]
		grid[x_value][y_value] = {"type": CELL_TYPE.EMPTY, "color": null}
		# 모래가 오른쪽 대각선 아래로 이동

##################################################
func _draw() -> void:
# queue_redraw()를 호출하면 다시 그려지는 함수
	for x in range(GRID_SIZE.x):
		for y in range(GRID_SIZE.y):
			if grid[x][y]["type"] == CELL_TYPE.SAND:
			# 현재 셀이  SAND 타입인지 확인
				var color_value: GM.CELL_COLOR = grid[x][y]["color"]
				# 저장된 색상 값을 가져옴
				var draw_color: Color = Color(1, 1, 0)
				# 기본 노랑. 예상하지 못한 null 방지

				match color_value:
					GM.CELL_COLOR.RED:
						draw_color = Color(1, 0, 0)
					GM.CELL_COLOR.YELLOW:
						draw_color = Color(1, 1, 0)
					GM.CELL_COLOR.GREEN:
						draw_color = Color(0, 1, 0)
					GM.CELL_COLOR.BLUE:
						draw_color = Color(0, 0, 1)
				# GM에서 정의한 색상과 매칭하여 적절한 색상 지정

				draw_rect(Rect2(x * PIXEL_SIZE, y * PIXEL_SIZE, \
					PIXEL_SIZE, PIXEL_SIZE), draw_color)
				# 모래 셀을 해당 색상으로 그림
				'''
				ㄴ draw_rect()는 _draw() 함수 안에서 사용되며,
				   지정된 사각형 영역을 원하는 색상으로 직접 그림
				ㄴ Rect2()는 2D 공간에서의 사각형 영역을 표현하는 클래스
				   충돌 영역, 화면 클리핑, UI 배치 등 다양한 곳에서 사용
				'''

##################################################
func input_left_mouse() -> void:
	if Input.is_action_pressed("ui_left_mouse"):
		var grid_x = int(get_global_mouse_position().x / PIXEL_SIZE)
		var grid_y = int(get_global_mouse_position().y / PIXEL_SIZE)
		# 마우스 위치를 그리드 좌표로 변환
		
		if grid_x >= 0 and grid_x < GRID_SIZE.x and \
			grid_y >= 0 and grid_y < GRID_SIZE.y:
		# 마우스 위치가 유효할 때
			grid[grid_x][grid_y] = {
				"type": CELL_TYPE.SAND,
				"color": GM.get_sand_color()}
		# GM 색에 맞춰 모래를 추가

##################################################
func input_accept() -> void:
# Enter 키를 누르면 모래의 색을 변경하는 함수
	if Input.is_action_just_pressed("ui_accept"):
	# Enter 키룰 누를 때
		if GM.get_sand_color() == GM.CELL_COLOR.RED:
			GM.set_sand_color(GM.CELL_COLOR.YELLOW)
		elif GM.get_sand_color() == GM.CELL_COLOR.YELLOW:
			GM.set_sand_color(GM.CELL_COLOR.GREEN)
		elif GM.get_sand_color() == GM.CELL_COLOR.GREEN:
			GM.set_sand_color(GM.CELL_COLOR.BLUE)
		elif GM.get_sand_color() == GM.CELL_COLOR.BLUE:
			GM.set_sand_color(GM.CELL_COLOR.RED)
		# GM에 저장된 색상을 순환 변경
