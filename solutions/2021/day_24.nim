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
  twentySix = initBigInt(26)
  twentyFive = initBigInt(25)


type
  Key = (int, BigInt, BigInt)
  Value = (BigInt, BigInt, BigInt, BigInt)
  Cache = TableRef[Key, Value]


proc runProgram(inputs: array[0..13, int], C1, C2, C3: seq[BigInt]): BigInt =
  func addOp(a: var BigInt, b: BigInt) = a = a + b
  func mulOp(a: var BigInt, b: BigInt) = a = a * b
  func modOp(a: var BigInt, b: BigInt) = a = a mod b
  func divOp(a: var BigInt, b: BigInt) = a = a div b
  func eqlOp(a: var BigInt, b: BigInt) = a = if a == b: one else: zero

  var
    w = zero
    x = zero
    y = zero
    z = zero

  proc once(i: int) =
    let
      c1 = C1[i]
      c2 = C2[i]
      c3 = C3[i]

    w = initBigInt(inputs[i]) # inpOp w
    mulOp x, zero
    addOp x, z
    modOp x, twentySix
    divOp z, c1
    addOp x, c2
    eqlOp x, w
    eqlOp x, zero
    mulOp y, zero
    addOp y, twentyFive
    mulOp y, x
    addOp y, one
    mulOp z, y
    mulOp y, zero
    addOp y, w
    addOp y, c3
    mulOp y, x
    addOp z, y

  for i in 0 .. 13:
    once(i)

  return z

import random

proc part1*(input: string): string =
  # let data = getData(input)

  let
    theSplit = input.strip().split("inp w")[1 .. ^1]
    C1 = theSplit.mapIt(it.splitLines()[04].scanTuple("div z $i")[1].initBigInt()).toSeq()
    C2 = theSplit.mapIt(it.splitLines()[05].scanTuple("add $w $i")[2].initBigInt()).toSeq()
    C3 = theSplit.mapIt(it.splitLines()[15].scanTuple("add $w $i")[2].initBigInt()).toSeq()

  echo C1
  echo C2
  echo C3

  const r = 1..9

  var
    # current = [8,9,9,5,9,7,9,9,9,9,9,9,9,9]
    current = [8,9,9,9,9,9,9,9,9,9,9,9,9,9]
    # Two hours on my laptop got me to: [8, 9, 9, 9, 7, 9, 2, 6, 4, 5, 6, 7, 1, 4]
    # 98999987787498
    # 99999987787587
    n = 0
    biggest: array[0..13, int]

  while true:
    inc n

    let value = runProgram(current, C1, C2, C3)

    if n mod 40000 == 0:
      echo current, ": ", value
      echo biggest.join("")
      n = 0

    if value == zero:
      echo "YES"
      if initBigInt(current.join("")) > initBigInt(biggest.join("")):
        biggest = current

      echo current.join("")
      echo biggest.join("")

    current = nextDown(current)


  return biggest.join("")


proc part2*(input: string): auto =
  let data = getData(input)
  return ""


const date* = (2021, 24)

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
