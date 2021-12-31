import aoc


type
  Point = tuple[x, y: int]
  Map = Table[Point, char]


func getData(input: string): (Map, int, int) =
  let lines = input.splitLines()

  var
    height = 0
    map: Map
    width = 0

  for y, line in lines:
    height = max(height, y)
    for x, character in line:
      width = max(width, x)
      map[(x, y)] = character

  return (map, height, width)


proc plot*(map: Map) =
  var value: string

  let points = map.keys.toSeq()
  for y in min(points.mapIt(it.y)) .. max(points.mapIt(it.y)):
    value &= "\n"
    for x in min(points.mapIt(it.x)) .. max(points.mapIt(it.x)):
      value &= $map[(x, y)]

  echo value


proc once(map: Map, height: int, width: int): Map =
  result = map.deepCopy()

  var
    emptyLocations: HashSet[Point]
    toMoveRight: HashSet[(Point, Point)]
    downPoints: HashSet[Point]

  for point in result.keys:
    let kind = map[point]

    case kind:
      of '.':
        emptyLocations.incl(point)
        continue

      of '>':
        var checkPoint = (point.x + 1, point.y)
        if checkPoint notin result:
          checkPoint = (0, point.y)

        if checkPoint in emptyLocations or result[checkPoint] == '.':
          toMoveRight.incl((point, checkPoint))

      of 'v':
        downPoints.incl(point)
        continue

      else: assert false

  for fromTo in toMoveRight:
    let (fromPoint, toPoint) = fromTo
    result[fromPoint] = '.'
    result[toPoint] = '>'
    emptyLocations.incl(fromPoint)
    emptyLocations.excl(toPoint)


  var toMoveDown: HashSet[(Point, Point)]
  for point in downPoints:
    var checkPoint = (point.x, point.y + 1)
    if checkPoint notin result:
      checkPoint = (point.x, 0)

    let checkValue = result[checkPoint]
    if checkPoint in emptyLocations or checkValue == '.':
      toMoveDown.incl((point, checkPoint))

  for fromTo in toMoveDown:
    let (fromPoint, toPoint) = fromTo
    result[fromPoint] = '.'
    result[toPoint] = 'v'


proc part1*(input: string): int =
  let (map, height, width) = getData(input)

  var previous = map
  while true:
    inc result
    let newMap = once(previous, height, width)

    if previous == newMap or result > 30000:
      break

    previous = newMap


proc part2*(input: string): string =
  return "Merry Christmas!"


const date* = (2021, 25)

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

