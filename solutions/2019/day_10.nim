import aoc


type
  Point = tuple[x, y: int]
  Field = tuple
    asteroids: HashSet[Point]
    width: int
    height: int


func getData(input: string): Field =
  let lines = input.split("\n")

  result.height = len(lines)
  result.width = len(lines[0])

  for y, line in lines:
    for x, character in line:
      if character == '#':
        result.asteroids.incl((x, y))


func checkIfInFiled(point: Point, width, height: int): bool =
  return 0 <= point.x and point.x < width and 0 <= point.y and point.y < height


func countAsteroids(base: Point, field: Field): int =
  var mutableAsteroids = field.asteroids.deepCopy()
  let (baseX, baseY) = base
  mutableAsteroids.excl(base)

  while len(mutableAsteroids) != 0:
    inc result

    let asteroid = mutableAsteroids.pop()
    var (dx, dy) = (asteroid.x - baseX, asteroid.y - baseY)
    let theValue = gcd(dx, dy)

    dx = dx div theValue
    dy = dy div theValue

    var currentPoint = base
    while checkIfInFiled(currentPoint, field.width, field.height):
      currentPoint.x += dx
      currentPoint.y += dy
      mutableAsteroids.excl(currentPoint)


proc part1*(input: string): int =
  let field = getData(input)

  for base in field.asteroids:
    result = max(countAsteroids(base, field), result)


proc part2*(input: string): auto =
  let data = getData(input)
  return ""


const date* = (2019, 10)

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
