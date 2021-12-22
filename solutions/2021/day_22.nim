import aoc


type
  Step = tuple[_: bool, onOff: string, x1, x2, y1, y2, z1, z2: int]
  Cube = tuple[x1, x2, y1, y2, z1, z2: int]


func getData(input: string): seq[Step] =
  input.splitLines.mapIt(it.scanTuple("$w x=$i..$i,y=$i..$i,z=$i..$i"))


func part1*(input: string): int =
  let steps = getData(input)

  var cubes: IntSet
  for step in steps:
    let
      (_, onOff, x1, x2, y1, y2, z1, z2) = step
      shouldTurnOn = onOff == "on"

    for x in max(x1, -50) .. min(x2, 50):
      for y in max(y1, -50) .. min(y2, 50):
        for z in max(z1, -50) .. min(z2, 50):
          let id = x + y * 10000 + z * 10000000

          if shouldTurnOn:
            cubes.incl(id)
          else:
            cubes.excl(id)

  return card(cubes)


func intersects(a, b: Cube|Step): bool =
  return a.x1 <= b.x2 and a.x2 >= b.x1 and
         a.y1 <= b.y2 and a.y2 >= b.y1 and
         a.z1 <= b.z2 and a.z2 >= b.z1


func volume(cube: Cube|Step): int =
  result = (cube.x2 - cube.x1 + 1) *
           (cube.y2 - cube.y1 + 1) *
           (cube.z2 - cube.z1 + 1)

  result = abs(result)


func getNonIntersectingVolume(cube: Cube, cubes: seq[Cube]): int =
  result = volume(cube)

  if result == 0:
    return

  var intersections: seq[Cube]
  for other in cubes:
    if not intersects(cube, other):
      continue

    let
      (x1, x2) = (max(cube.x1, other.x1), min(cube.x2, other.x2))
      (y1, y2) = (max(cube.y1, other.y1), min(cube.y2, other.y2))
      (z1, z2) = (max(cube.z1, other.z1), min(cube.z2, other.z2))
      intersection: Cube = (x1, x2, y1, y2, z1, z2)

    intersections.add(intersection)

  for i, intersection in intersections:
    result -= getNonIntersectingVolume(intersection, intersections[i+1 .. ^1])


proc part2*(input: string): int =
  let
    steps = getData(input)
    cubes = steps.mapIt((it.x1, it.x2, it.y1, it.y2, it.z1, it.z2).Cube)

  for i, step in steps:
    let shouldTurnOn = step.onOff == "on"

    if shouldTurnOn:
      result += getNonIntersectingVolume(cubes[i], cubes[i+1 .. ^1])


const date* = (2021, 22)

proc main*() =
  doAssert volume(getData("on x=10..12,y=10..12,z=10..12")[0]) == 3*3*3
  doAssert volume(getData("on x=11..13,y=11..13,z=11..13")[0]) == 3*3*3
  doAssert volume(getData("on x=-1..13,y=-1..13,z=-1..13")[0]) == 15*15*15

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
