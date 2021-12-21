import aoc



const size = 400
type
  Map = array[0 .. size, array[0 .. size, int]]
  Point = tuple[x, y: int]


func getData(input: string): seq[Point] =
  let lines = input.splitLines()

  for i, line in lines:
    let (ok, x, y) = line.scanTuple("$i, $i")
    if ok: result &= (x, y)


func manhattan(a, b: Point): int =
  abs(a.x - b.x) + abs(a.y - b.y)


func getSideIDS(map: Map): IntSet =
  let
    top = map[0].mapIt(it)
    bottom = map[^1].mapIt(it)
    left = map.mapIt(it[0])
    right = map.mapIt(it[^1])

  return (top & bottom & left & right).toIntSet()


func getMapAndSizes(points: seq[Point]): tuple[map: Map, sizes: CountTable[int]] =
  for y in 0 .. size:
    for x in 0 .. size:
      var
        currentID = -1
        minimalDistance = int.high

      let current: Point = (x, y)
      for index, point in points:
        let
          id = index + 1
          distance = manhattan(current, point)

        if distance < minimalDistance:
          minimalDistance = distance
          currentID = id
        elif distance == minimalDistance:
          currentID = 0

      if currentID != 0:
        result.map[y][x] = currentID
        result.sizes.inc(currentID)


func getTotal(points: seq[Point]): int =
  for y in 0 .. size:
    for x in 0 .. size:
      var total: int

      let current: Point = (x, y)
      for i, point in points:
        total += manhattan(current, point)

      if total < 10000:
        inc result


proc part1*(input: string): int =
  let
    points = getData(input)
    (map, sizes) = getMapAndSizes(points)

  let sideIDS = map.getSideIDS()
  for id in sizes.keys:
    let size = sizes[id]
    if id notin sideIDS:
      result = max(result, size)

  doAssert result != 0


proc part2*(input: string): int =
  let points = getData(input)
  return getTotal(points)


const date* = (2018, 6)

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
