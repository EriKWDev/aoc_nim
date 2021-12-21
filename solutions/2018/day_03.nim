import aoc


type
  Claim = tuple[_: bool, id, left, top, width, height: int]
  Point = tuple[x, y: int]


func getData(input: string): seq[Claim] =
  input.splitLines().mapIt(it.scanTuple("#$i @ $i,$i: $ix$i"))


proc part1*(input: string): int =
  let claims = getData(input)

  var
    map: CountTable[Point]
    covered: HashSet[Point]

  for claim in claims:
    let (_, _, left, top, width, height) = claim

    for x in left ..< left + width:
      for y in top ..< top + height:
        let point: Point = (x, y)
        map.inc(point)

        if map[point] >= 2:
          covered.incl(point)

  return card(covered)


proc part2*(input: string): int =
  let claims = getData(input)

  var
    map: Table[int, HashSet[Point]]
    covered: HashSet[Point]
    candidates: IntSet

  for claim in claims:
    let (_, id, left, top, width, height) = claim
    var overlaps = false

    for x in left ..< left + width:
      for y in top ..< top + height:
        let point: Point = (x, y)

        if point in covered:
          overlaps = true

        if id notin map:
          map[id] = initHashSet[Point]()

        covered.incl(point)
        map[id].incl(point)

    if overlaps == false:
      candidates.incl(id)


  for candidate1 in candidates:
    var overlaps = false

    for candidate2 in map.keys:
      if candidate1 == candidate2: continue

      if card(map[candidate1] * map[candidate2]) > 0:
        overlaps = true
        break

    if overlaps == false:
      result = candidate1


const date* = (2018, 3)

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
