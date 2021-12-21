import aoc


type
  Point = tuple[x, y: int]
  Map = HashSet[Point]
  Data = tuple[map: Map, algorithm: string]


func getData(input: string): Data =
  let chunks = input.split("\n\n")
  result.algorithm = chunks[0].strip().replace("\n", "").replace(".", "0").replace("#", "1")

  let lines = chunks[1].strip().splitLines()
  for y, line in lines:
    for x, character in line:
      let point: Point = (x, y)

      if character == '#':
        result.map.incl(point)


func findValue(map: Map, algorithm: string, point: Point, depth: int, cache: var Table[(Point, int), string]): string =
  let key = (point, depth)
  if key in cache: return cache[key]

  if depth == 0:
    result = if point in map: "1" else: "0"
  else:
    var binary = ""
    for dy in -1 .. 1:
      for dx in -1 .. 1:
        let newPoint: Point = (point.x + dx, point.y + dy)

        binary &= findValue(map, algorithm, newPoint, depth - 1, cache)

    let index = fromBin[int](binary)
    result = $algorithm[index]

  cache[key] = result


func solve(map: Map, algorithm: string, n: int): int =
  var cache: Table[(Point, int), string]

  const padding = 100

  for y in -n .. n + padding:
    for x in -n .. n + padding:
      if findValue(map, algorithm, (x, y), n, cache) == "1":
        inc result


func part1*(input: string): int =
  let (map, algorithm) = getData(input)
  return solve(map, algorithm, 2)


func part2*(input: string): int =
  let (map, algorithm) = getData(input)
  return solve(map, algorithm, 50)


const date* = (2021, 20)

proc main*() =
  let input = fetchInput(date)

  if not runExamples1(date, part1): return
  let answer1 = part1(input)
  printAnswer(answer1)
  # submit1(date, answer1)

  if not runExamples2(date, part2): return
  let answer2 = part2(input)
  printAnswer(answer2)
  submit2(date, answer2)


when isMainModule:
  main()
