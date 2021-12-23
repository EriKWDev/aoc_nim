import aoc


type
  Point = tuple[x, y: int]
  Data = tuple[map: Table[Point, char], ampiphodPoints: HashSet[Point]]
  Move = tuple[startPoint, endPoint: Point, cost: int, settled: bool]


const
  deltas: array[4, Point] = [(0, 1), (0, -1), (1, 0), (-1, 0)]

  ampiphodTypes = {'A' .. 'D'}
  energyMap = ampiphodTypes.mapIt((it, 10^(it.ord() - 'A'.ord()))).toTable()
  targetX = ampiphodTypes.mapIt((it, 3 + 2 * (it.ord() - 'A'.ord()))).toTable()
  forbiddenStops: HashSet[Point] = targetX.values.toSeq().mapIt((it, 1)).toHashSet()


func getData(input: string): Data =
  let lines = input.splitLines()
  for y, line in lines:
    for x, character in line:
      let point: Point = (x, y)

      result.map[point] = character
      if character in ampiphodTypes:
        if y == lines.high - 1 and x == targetX[character]:
          result.map[point] = character
          continue

        result.ampiphodPoints.incl(point)


func `$`(data: Data): string =
  let
    points = data.map.keys.toSeq()
    minX = min(points.mapIt(it.x))
    maxX = max(points.mapIt(it.x))
    minY = min(points.mapIt(it.y))
    maxY = max(points.mapIt(it.y))

  result = "   "

  for x in minX .. maxX:
    result &= (&"{x:2}")[0]
  result &= "\n   "

  for x in minX .. maxX:
    result &= (&"{x:2}")[1]
  result &= "\n"

  for y in minY .. maxY:
    result &= &"\n{y:2} "
    for x in minX .. maxX:
      let point: Point = (x, y)
      if point notin data.map:
        result &= ' '
        continue

      result &= data.map[point]


func `$`(move: Move): string =
  &"({move.startPoint.x}, {move.startPoint.y}) -> ({move.endPoint.x}, {move.endPoint.y}) ({move.cost}, {move.settled})"


func getMoves(data: Data, startPoint: Point): seq[Move] =
  var
    dfs = @[(startPoint, 0)].toDeque()
    visited = [startPoint].toHashSet()

  let ampiphodKind = data.map[startPoint]

  while len(dfs) > 0:
    let (point, steps) = dfs.popFirst()
    visited.incl(point)

    for delta in deltas:
      let
        endPoint: Point = (point.x + delta.x, point.y + delta.y)
        newSteps = steps + 1

      if endPoint in visited:
        continue

      if data.map[endPoint] != '.':
        continue

      dfs.addLast((endPoint, newSteps))

      if endPoint in forbiddenStops:
        continue

      if endPoint.x != targetX[ampiphodKind] and endPoint.y > 1:
        continue

      if endPoint.y == 1 and startPoint.y != 1:
        result.add((startPoint, endPoint, newSteps * energyMap[ampiphodKind], false))

      if endPoint.y == 2:
        var
          onlySame = true
          extraY = 0
          y = endpoint.y

        while true:
          inc y
          let current = data.map[(endPoint.x, y)]

          if current == '.':
            inc extraY
            continue

          if current == '#':
            break

          if current != ampiphodKind:
            onlySame = false
            break

        if onlySame:
          let newEndpoint: Point = (endPoint.x, endPoint.y + extraY)
          result.add((startPoint, newEndpoint, (newSteps + extraY) * energyMap[ampiphodKind], true))


func getMoves(data: Data): seq[Move] =
  for startPoint in data.ampiphodPoints:
    let moves = data.getMoves(startPoint)
    result.add(moves)


proc solveImpl(data: Data, cache: var Table[Data, int]): int =
  if len(data.ampiphodPoints) == 0:
    return 0

  if data in cache:
    return cache[data]

  result = 1000000
  let validMoves = data.getMoves()
  for move in validMoves:
    var newData = data.deepCopy()
    let
      (startPoint, endPoint, cost, settled) = move
      ampiphodKind = newData.map[startPoint]

    newData.ampiphodPoints.excl(startPoint)
    newData.map[endPoint] = ampiphodKind

    if not settled:
      newData.ampiphodPoints.incl(endPoint)

    newData.map[startPoint] = '.'
    let totalCost = cost + solveImpl(newData, cache)

    if result == 0: result = totalCost
    result = min(totalCost, result)

  cache[data] = result


proc solve(data: Data): int =
  var cache: Table[Data, int]
  return solveImpl(data, cache)


proc part1*(input: string): auto =
  let data = getData(input)
  return data.solve()


const part2ExtraLines = ["  #D#C#B#A#", "  #D#B#A#C#"]

proc part2*(input: string): auto =
  var lines = input.splitLines()

  lines.insert(part2ExtraLines[1], 3)
  lines.insert(part2ExtraLines[0], 3)
  let newInput = lines.join("\n")

  var data = getData(newInput)
  return data.solve()


const date* = (2021, 23)


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
