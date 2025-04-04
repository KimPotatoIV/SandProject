extends Node2D

##################################################
enum CELL_TYPE {
	EMPTY,
	SAND,
	SOLID
	}
# 셀 타입을 열거형으로 정의

const REF_SIZE: int = 5
const GRID_SIZE = Vector2i(360 / REF_SIZE, 640 / REF_SIZE)
const PIXEL_SIZE = 1 * REF_SIZE
# 그리드 크기 및 픽셀 설정
# PIXEL_SIZE는 모래 한 알의 크기

var grid: Array = []
# 그리드 저장소

##################################################
func _ready() -> void:
	init_grid()
	# 빈 그리드 배열(CELL_TYPE.EMPTY)을 생성하는 함수

##################################################
func _process(delta: float) -> void:
	for x in range(GRID_SIZE.x):
		for y in range(GRID_SIZE.y - 1, -1, -1):
		# GRID_SIZE.y - 1부터 -1 전까지 역순(-1)으로 반복
			if grid[x][y]["type"] == CELL_TYPE.SAND:
				flow_sand(x, y)
	# 모래의 낙하를 처리 하며 아래에서 위로 검사하여 모래가 아래로 흐를 수 있도록 함
	
	input_left_mouse()
	input_accept()
	# 입력 처리 함수 호출
	
	queue_redraw()
	# 화면 다시 그리기
	
	remove_connected_line()

##################################################
func init_grid() -> void:
	for x in range(GRID_SIZE.x):
		grid.append([])
		for y in range(GRID_SIZE.y):
			grid[x].append({"type": CELL_TYPE.EMPTY, "color": null})
	# 빈 그리드 배열(CELL_TYPE.EMPTY)을 생성하는

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
			# 현재 셀이 SAND 타입인지 확인
				var color_value: GM.CELL_COLOR = grid[x][y]["color"]
				# 저장된 색상 값을 가져옴
				var draw_color: Color = Color(1, 0, 0)
				# 기본 빨강. 예상하지 못한 null 방지

				match color_value:
					GM.CELL_COLOR.RED:
						draw_color = Color(1, 0, 0)
					GM.CELL_COLOR.YELLOW:
						draw_color = Color(1, 1, 0)
					GM.CELL_COLOR.GREEN:
						draw_color = Color(0, 1, 0)
					GM.CELL_COLOR.BLUE:
						draw_color = Color(0, 0, 1)
				# 저장된 색상과 매칭하여 적절한 색상 지정

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
				"type": CELL_TYPE.SAND, "color": GM.get_sand_color()
				}
			# GM 색에 맞춰 모래를 뿌림

##################################################
func input_accept() -> void:
# Enter 키를 누르면 모래의 색을 변경하는 함수
	if Input.is_action_just_pressed("ui_accept"):
	# Enter or Space 키를 누를 때
		if GM.get_sand_color() == GM.CELL_COLOR.RED:
			GM.set_sand_color(GM.CELL_COLOR.YELLOW)
		elif GM.get_sand_color() == GM.CELL_COLOR.YELLOW:
			GM.set_sand_color(GM.CELL_COLOR.GREEN)
		elif GM.get_sand_color() == GM.CELL_COLOR.GREEN:
			GM.set_sand_color(GM.CELL_COLOR.BLUE)
		elif GM.get_sand_color() == GM.CELL_COLOR.BLUE:
			GM.set_sand_color(GM.CELL_COLOR.RED)
		# GM에 저장된 색상을 순환 변경

##################################################
func remove_connected_line() -> void:
	var visited: Dictionary = {}
	# 이미 방문한 셀 좌표를 저장. 중복 탐색 방지용
	
	for x in range(GRID_SIZE.x):
		for y in range(GRID_SIZE.y):
	# 모든 셀을 순회하면서
			if grid[x][y]["type"] == CELL_TYPE.SAND and not visited.has(Vector2i(x, y)):
			# 현재 셀이 SAND이고 아직 방문하지 않은 경우
				var same_color: GM.CELL_COLOR = grid[x][y]["color"]
				# 현재 셀의 색상 정보를 가져옴
				var connected: Array = []
				# 연결된 같은 색상의 모래 셀 목록
				var queue: Array = [Vector2i(x, y)]
				# BFS 탐색용 대기열. 시작점은 현재 셀
				var has_left: bool = false
				var has_right: bool = false
				# 이 그룹이 화면의 왼쪽 끝과 오른쪽 끝에 닿았는지 추적
				
				while queue.size() > 0:
				# BFS 탐색 수행
					var pos = queue.pop_front()
					if visited.has(pos):
						continue
					# 이미 방문한 셀은 건너뜀
					
					visited[pos] = true
					connected.append(pos)
					# 현재 셀을 방문 처리 및 연결 그룹에 추가
					
					if pos.x == 0:
						has_left = true
					if pos.x == GRID_SIZE.x - 1:
						has_right = true
					# 이 셀이 화면 왼쪽 끝 또는 오른쪽 끝에 닿았는지 확인
					
					for offset in [Vector2i(-1, 0), Vector2i(1, 0), \
						Vector2i(0, -1), Vector2i(0, 1)]:
					# 상하좌우 네 방향 이웃을 검사
						var neighbor = pos + offset
						if neighbor.x >= 0 and neighbor.x < GRID_SIZE.x and \
							neighbor.y >= 0 and neighbor.y < GRID_SIZE.y:
						# 범위 안에 있는 좌표만 검사
							if grid[neighbor.x][neighbor.y]["type"] == CELL_TYPE.SAND and \
								grid[neighbor.x][neighbor.y]["color"] == same_color and \
								not visited.has(neighbor):
							# 이웃 셀이 같은 색상의 모래이고, 아직 방문하지 않았다면
								queue.append(neighbor)
				
				if has_left and has_right:
				# 이 연결된 그룹이 왼쪽 끝과 오른쪽 끝에 모두 닿은 경우
					for pos in connected:
						grid[pos.x][pos.y] = {"type": CELL_TYPE.EMPTY, "color": null}
					# 해당 셀을 제거하여 비우기
