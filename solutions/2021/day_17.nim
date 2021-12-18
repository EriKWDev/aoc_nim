import aoc


type Data = tuple[x1, x2, y1, y2: int]


func getData(input: string): Data =
  let
    numbersPattern = re"(?m)(-?\d+)"
    numbers = input.findAll(numbersPattern).mapIt(parseInt(it.group(0, input)[0]))
  return (numbers[0], numbers[1], numbers[2], numbers[3])


func simulate(area: Data, initialVX, initialVY: int): tuple[reachedArea: bool, highestY: int] =
  var
    isInFrontOfArea = true
    x = 0
    y = 0
    vx = initialVX
    vy = initialVY
    (lx, hx, ly, hy) = area

  while isInFrontOfArea:
    x += vx
    y += vy

    result.highestY = max(result.highestY, y)

    if vx != 0:
      if vx < 0: inc vx else: dec vx

    dec vy

    if not result.reachedArea:
      result.reachedArea = x >= lx and x <= hx and y <= hy and y >= ly

      if result.reachedArea: break

    isInFrontOfArea =
      x <= hx and
      y >= ly


proc part1*(input: string): int =
  let area = getData(input)

  for x in 0 .. 100:
    for y in 0 .. 100:
      let (reachedArea, highestY) = area.simulate(x, y)

      if reachedArea == true:
        result = max(result, highestY)


proc part2*(input: string): auto =
  let area = getData(input)
  var distinctVelocities: HashSet[(int, int)]

  for x in -100 .. 200:
    for y in -500 .. 500:
      let vel = (x, y)
      if vel in distinctVelocities: continue

      let (reachedArea, _) = area.simulate(x, y)

      if reachedArea == true:
        distinctVelocities.incl(vel)

  return len(distinctVelocities)


const date* = (2021, 17)

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
