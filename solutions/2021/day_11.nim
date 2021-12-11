import aoc

type Map = Table[tuple[x, y: int], int]

proc getData(input: string): Map =
  let
    lines = input.split("\n")

  var map: Map
  for y, line in lines:
    for x, character in line:
      let value = parseInt($character)
      map[(x, y)] = value

  return map


proc oneRound(map: var Map) =
  for location in map.keys:
    inc map[location]


proc flash(map: var Map, location: tuple[x, y: int], flashed: var HashSet[tuple[x, y: int]]): int =
  if location notin map:
    return 0

  if location in flashed:
    return 0

  inc map[location]

  if map[location] > 9:
    map[location] = 0
    result = 1

    flashed.incl(location)

    for dx in -1 .. 1:
      for dy in -1 .. 1:
        if dx == 0 and dy == 0: continue

        let newLocation = (location.x + dx, location.y + dy)

        result += flash(map, newLocation, flashed)


proc part1*(input: string): int =
  var map = getData(input)
  result = 0

  for i in 1 .. 100:
    var flashed: HashSet[tuple[x, y: int]]

    map.oneRound()

    for location in map.keys:
      if map[location] > 9:
        result += flash(map, location, flashed)


proc part2*(input: string): auto =
  const maxLevel = 1000

  var map = getData(input)
  result = 0

  for i in 1 .. maxLevel:
    map.oneRound()

    var flashed: HashSet[tuple[x, y: int]]
    for location in map.keys:
      if map[location] > 9:
        result += flash(map, location, flashed)

    var allIsZero = true
    for value in map.values:
      if value != 0:
        allIsZero = false
        break

    if allIsZero:
      return i


const date* = (2021, 11)

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
