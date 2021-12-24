import aoc, bigints


type Instruction = (int, string, string, string)

func getData(input: string): seq[Instruction] =
  let lines = input.splitLines()
  for line in lines:
    let theSplit = line.split(" ")
    if len(theSplit) == 2:
      result &= (len(theSplit), theSplit[0], theSplit[1], "")
    else:
      result &= (len(theSplit), theSplit[0], theSplit[1], theSplit[2])


func nextDown(values: array[0..13, int]): array[0..13, int] =
  for i in 0 .. 13:
    result[i] = values[i]

  var i = 13
  while true:
    result[i] = (result[i] - 1)

    if result[i] != 0:
      break

    result[i] = 9
    dec i


func nextUp(values: array[0..13, int]): array[0..13, int] =
  for i in 0 .. 13:
    result[i] = values[i]

  var i = 13
  while true:
    result[i] = (result[i] + 1)

    if result[i] < 9:
      break

    result[i] = 1
    dec i

const
  zero = initBigInt(0)
  one = initBigInt(1)

  C1 = [+12, +11, +12, -03, +10, -09, +10, -07, -11, -04, +14, +11, -08, -10].mapIt(initBigInt(it))
  C2 = [+07, +15, +02, +15, +14, +02, +15, +01, +15, +15, +12, +02, +13, +13].mapIt(initBigInt(it))
  C3 = [+01, +01, +01, +26, +01, +26, +01, +26, +26, +26, +01, +01, +26, +26].mapIt(initBigInt(it))

  twentySix = initBigInt(26)


proc runProgram(program: seq[Instruction], inputs: array[0..13, int]): BigInt =
  var
    x = zero
    y = zero
    z = zero
    w = zero

  for i in 0 .. high(C1):
    let (c1, c2, c3) = (C1[i], C2[i], C3[i])

    w = initBigInt(inputs[i])

    x = z mod twentySix
    z = z div c3
    x = if x + c1 == w: zero else: one

    let
      a = if x == one: twentySix else: one
      b = if x == one: w + c2 else: zero

    z = z * a + b

  return z


proc part1*(input: string): string =
  let data = getData(input)

  var
    current = [9, 9, 9, 9, 9, 9, 3, 1, 6, 6, 4, 7, 7, 8]
    n = 0
    biggest: BigInt = zero

  while true:
    inc n

    let value = data.runProgram(current)

    if n mod 40000 == 0:
      echo current, ": ", value
      n = 0

    if value == zero:
      echo "YES"
      biggest = max(biggest, initBigInt(current.join("")))
      echo biggest

    current = nextDown(current)

  return $biggest

proc part2*(input: string): auto =
  let data = getData(input)
  return ""


const date* = (2021, 24)

proc main*() =
  let input = fetchInput(date)

  if not runExamples1(date, part1): return
  let answer1 = part1(input)
  printAnswer(answer1)
  submit1(date, answer1)

  if not runExamples2(date, part2): return
  let answer2 = part2(input)
  printAnswer(answer2)
  submit2(date, answer2)


when isMainModule:
  main()
