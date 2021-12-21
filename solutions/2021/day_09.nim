import aoc


type Map = Table[tuple[x, y: int], int]

func getData(input: string): Map =
  let lines = input.split("\n")

  for y, line in lines:
    for x, character in line:
      let value = parseInt($character)
      result[(x, y)] = value


func isLowPoint(map: Map, pos: tuple[x, y: int]): bool =
  result = true

  let value = map[pos]

  for delta in [[-1, 0], [0, -1], [1, 0], [0, 1]]:
    var
      newPos = (x: pos.x + delta[0], y: pos.y + delta[1])

    if newPos notin map:
      continue

    if value >= map[newPos]:
      result = false
      break


func part1*(input: string): int =
  let map = getData(input)

  for pos in map.keys:
    if map.isLowPoint(pos):
      result += map[pos] + 1


func getBasinSize(map: Map, pos, prevpos: tuple[x, y: int], visitedPoints: var HashSet[tuple[x,
    y: int]]): int =
  let value = map[pos]
  if value == 9: return 0
  if pos in visitedPoints: return 0

  result = 1
  visitedPoints.incl(pos)

  for delta in [[-1, 0], [0, -1], [1, 0], [0, 1]]:
    let newPos = (x: pos.x + delta[0], y: pos.y + delta[1])

    if newPos notin map: continue
    if newPos == prevPos: continue

    if map[newPos] > value:
      result += getBasinSize(map, newPos, pos, visitedPoints)


func part2*(input: string): int =
  let data = getData(input)
  var basins: seq[int]

  for pos in data.keys:
    if not data.isLowPoint(pos): continue

    var visitedPoints: HashSet[tuple[x: int, y: int]]
    let basinSize = data.getBasinSize(pos, pos, visitedPoints)

    basins.add(basinSize)

  let values = sorted(basins, SortOrder.Descending)
  return values[0] * values[1] * values[2]


const date* = (2021, 9)

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
