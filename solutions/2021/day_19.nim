import aoc, hashes


type Point = tuple[x, y, z: int]


func hash*(point: Point): Hash = point.x + point.y * 10000 + point.z * 100000000


func getData(input: string): seq[HashSet[Point]] =
  for scannerBlock in input.split("\n\n"):
    let lines = scannerBlock.splitLines()[1 .. ^1]
    var points: HashSet[Point]

    for line in lines:
      let (ok, x, y, z) = line.scanTuple("$i,$i,$i")
      assert ok == true
      points.incl((x, y, z))

    result.add(points)


func sub(a, b: Point): Point {.inline.} = (a.x - b.x, a.y - b.y, a.z - b.z)
func add(a, b: Point): Point {.inline.} = (a.x + b.x, a.y + b.y, a.z + b.z)
func manhattanDistance(a, b: Point): int {.inline.} = abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z)


func getRotations(point: Point): array[24, Point] =
  let (x, y, z) = point

  return [
    (+x, +y, +z), (+y, +z, +x), (+z, +x, +y), (+z, +y, -x), (+y, +x, -z), (+x, +z, -y),
    (+x, -y, -z), (+y, -z, -x), (+z, -x, -y), (+z, -y, +x), (+y, -x, +z), (+x, -z, +y),
    (-x, +y, -z), (-y, +z, -x), (-z, +x, -y), (-z, +y, +x), (-y, +x, +z), (-x, +z, +y),
    (-x, -y, +z), (-y, -z, +x), (-z, -x, +y), (-z, -y, -x), (-y, -x, -z), (-x, -z, -y)
  ]


func findMatching(knownPoints: HashSet[Point], scanners: seq[HashSet[Point]]): (Point, HashSet[Point], int) =
  for index, scanner in scanners:
    let allRotations = scanner.map(getRotations)

    for i in 0 ..< 24:
      let rotatedPoints = allRotations.mapIt(it[i])

      for knownPoint in knownPoints:
        for i, rotatedPoint in rotatedPoints:
          let diff = sub(knownPoint, rotatedPoint)

          var matches = 1
          for point in rotatedPoints:
            let newPoint = add(point, diff)

            if newPoint in knownPoints:
              inc matches

          if matches >= 12:
            var res: HashSet[Point]
            for p in rotatedPoints:
              res.incl(add(p, diff))

            return (diff, res, index)

  doAssert false


func part1*(input: string): int =
  var
    scanners = getData(input)
    knownPoints = scanners[0]

  scanners.del(0)

  while len(scanners) > 0:
    let (_, matching, scannerIndex) = findMatching(knownPoints, scanners)
    knownPoints.incl(matching)
    scanners.del(scannerIndex)

  return len(knownPoints)


func part2*(input: string): int =
  var
    scanners = getData(input)
    knownPoints = scanners[0]
    scannerPositions: HashSet[Point]

  scanners.del(0)
  scannerPositions.incl((0, 0, 0))

  while len(scanners) > 0:
    let (diff, matching, scannerIndex) = findMatching(knownPoints, scanners)
    knownPoints.incl(matching)
    scanners.del(scannerIndex)
    scannerPositions.incl(diff)

  for a in scannerPositions:
    for b in scannerPositions:
      result = max(manhattanDistance(a, b), result)


const date* = (2021, 19)

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
