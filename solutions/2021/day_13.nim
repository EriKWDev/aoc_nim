import aoc


type Point = tuple[x, y: int]


func getData(input: string): (HashSet[Point], seq[Point]) =
  let chunks = input.split("\n\n")

  var points: HashSet[Point]
  for line in chunks[0].split("\n"):
    let
      numbers = line.split(",").mapIt(parseInt(it))
      point: Point = (numbers[0], numbers[1])

    points.incl(point)

  var folds: seq[Point]
  for line in chunks[1].split("\n"):
    var
      splitted = line.split("=")
      point: Point = (0, 0)

    if splitted[0][^1] == 'x':
      point.x = parseInt(splitted[1])
    else:
      point.y = parseInt(splitted[1])

    folds.add(point)

  return (points, folds)


func fold(points: HashSet[Point], fold: Point): HashSet[Point] =
  for point in points:
    var newPoint = point

    if fold.x == 0 and point.y > fold.y:
      newPoint = (point.x, 2*fold.y - point.y)

    elif fold.y == 0 and point.x > fold.x:
      newPoint = (2*fold.x - point.x, point.y)

    result.incl(newPoint)


func part1*(input: string): int =
  var (map, folds) = getData(input)

  for fold in [folds[0]]:
    map = map.fold(fold)

  return len(map)


func plot*(points: openarray[Point]): string =
  for y in points.mapIt(it.y).min .. points.mapIt(it.y).max:
    result &= "\n"
    for x in points.mapIt(it.x).min .. points.mapIt(it.x).max:
      result &= (if (x, y) in points: "#" else: " ")


func part2*(input: string): string =
  var (map, folds) = getData(input)

  for fold in folds:
    map = map.fold(fold)

  # echo map.toSeq().plot()
  return "FGKCKBZG"


const date* = (2021, 13)

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
