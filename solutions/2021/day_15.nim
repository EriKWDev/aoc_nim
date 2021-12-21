import aoc


type
  Point = tuple[x, y: int]
  Map = Table[Point, int]


func getData(input: string): Map =
  let lines = input.splitLines()

  for y, line in lines:
    for x, character in line:
      let value = parseInt($character)
      result[(x, y)] = value


proc plot*(map: Map) =
  var value: string

  let points = map.keys.toSeq()
  for y in min(points.mapIt(it.y)) .. max(points.mapIt(it.y)):
    value &= "\n"
    for x in min(points.mapIt(it.x)) .. max(points.mapIt(it.x)):
      value &= $map[(x, y)]

  echo value


func estimate(map: Map, start: Point, goal: Point): int {.inline.} =
  return (sqrt(((start.x * goal.x) + (goal.y * start.y)).float) * 10).int


func reconstructPath(cameFrom: Table[Point, Point], finish: Point): seq[Point] =
  result.add(finish)

  var next = finish
  while next in cameFrom:
    next = cameFrom[next]
    result.add(next)

  return reversed(result)


func solve(map: Map, start: Point, goal: Point): seq[Point] =
  var
    openPoints: HashSet[Point]
    cameFrom: Table[Point, Point]
    gScore: Map
    fScore: Map

  openPoints.incl(start)
  gScore[start] = 0
  fScore[start] = map.estimate(start, goal)

  while len(openPoints) != 0:
    var
      currentPoint: Point
      currentLowest = int.high

    for point in openPoints:
      if point notin fScore:
        fScore[point] = int.high

      if fScore[point] <= currentLowest:
        currentLowest = fScore[point]
        currentPoint = point

    openPoints.excl(currentPoint)

    if currentPoint == goal:
      return cameFrom.reconstructPath(currentPoint)

    for delta in [[0, 1], [1, 0], [0, -1], [-1, 0]]:
      let nextPoint: Point = (currentPoint.x + delta[0], currentPoint.y + delta[1])
      if nextPoint notin map: continue

      for point in [currentPoint, nextPoint]:
        if point notin gScore:
          gScore[point] = int.high

      let tentativeScore = gScore[currentPoint] + map[nextPoint]

      if tentativeScore < gScore[nextPoint]:
        cameFrom[nextPoint] = currentPoint
        gScore[nextPoint] = tentativeScore
        fScore[nextPoint] = tentativeScore + map.estimate(nextPoint, goal)

        openPoints.incl(nextPoint)


func getGoal(map: Map): Point =
  for key in map.keys:
    if key.x >= result.x and key.y >= result.y:
      result = key


func part1*(input: string): int =
  let
    map: Map = getData(input)
    start: Point = (0, 0)
    goal: Point = map.getGoal()

  let solution = map.solve(start, goal)
  return solution.mapIt(map[it]).toSeq().sum() - map[start]


func repeat(map: Map, n: int): Map =
  let
    goal = map.getGoal()
    width = goal.x + 1
    height = goal.y + 1

  for x in 0 ..< width * n:
    for y in 0 ..< height * n:
      let
        point = (x, y)
        mappedPoint = (x mod width, y mod height)
        extra = x div width + y div height

      result[point] = map[mappedPoint] - 1 + extra
      result[point] = result[point] mod 9 + 1


func part2*(input: string): auto =
  let
    initialMap: Map = getData(input)
    map = initialMap.repeat(5)
    start: Point = (0, 0)
    goal = map.getGoal()

  let solution = map.solve(start, goal)
  return solution.mapIt(map[it]).toSeq().sum() - map[start]


const date* = (2021, 15)

proc main*() =
  let input = fetchInput(date)

  if not runExamples1(date, part1): return
  let answer1 = part1(input)
  printAnswer(answer1)
  # submit1(date, answer1)

  if not runExamples2(date, part2): return
  let answer2 = part2(input)
  printAnswer(answer2)
  # submit2(date, answer2)


when isMainModule:
  main()
