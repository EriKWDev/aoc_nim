import aoc


type Data = tuple[C1, C2, C3: seq[int]]


proc getData(input: string): Data =
  result.C1 = newSeqOfCap[int](13)
  result.C2 = newSeqOfCap[int](13)
  result.C3 = newSeqOfCap[int](13)

  let lines = input.splitLines()
  var
    i = 0
    n = 0

  while n <= high(lines):
    let line = lines[n]
    if line.contains("inp"):
      result.C1.add lines[n + 4].split(" ")[2].parseInt()
      result.C2.add lines[n + 5].split(" ")[2].parseInt()
      result.C3.add lines[n + 15].split(" ")[2].parseInt()

      inc i
      n += 18


func addOp(a: var int, b: int) = a = a + b
func mulOp(a: var int, b: int) = a = a * b
func modOp(a: var int, b: int) = a = a mod b
func divOp(a: var int, b: int) = a = a div b
func eqlOp(a: var int, b: int) = a = if a == b: 1 else: 0


proc runProgramOnce(input, previousZ, c1, c2, c3: int): int =
  var
    w = input
    z = previousZ
    x = 0
    y = 0

  # mulOp x, 0
  addOp x, z
  modOp x, 26
  divOp z, c1
  addOp x, c2
  eqlOp x, w
  eqlOp x, 0
  # mulOp y, 0
  addOp y, 25
  mulOp y, x
  addOp y, 1
  mulOp z, y
  mulOp y, 0
  addOp y, w
  addOp y, c3
  mulOp y, x
  addOp z, y

  result = z


const maxZValue = 10 ^ 8 # Arbitrary large number

proc part1*(input: string): string =
  let (C1, C2, C3) = getData(input)

  var results = {0: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]}.toOrderedTable()
  for i in 0 ..< 14:

    let (c1, c2, c3) = (C1[i], C2[i], C3[i])
    var newResults: OrderedTable[int, array[14, int]]

    for previousZ, previousValue in results.pairs:
      for input in 1 .. 9:
        let newZ = runProgramOnce(input, previousZ, c1, c2, c3)

        if newZ > maxZValue:
          continue

        var newValue = previousValue
        newValue[i] = input
        newResults[newZ] = newValue

    results = newResults

    # 87559244919519
    # 89959794919939
    # 87959131916919
    # 89115794919139
    # 87248792917219
    # 89448242917439

  return results[0].join("")


proc part2*(input: string): string =
  let (C1, C2, C3) = getData(input)

  var results = {0: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]}.toOrderedTable()
  for i in 0 ..< 14:

    let (c1, c2, c3) = (C1[i], C2[i], C3[i])
    var newResults: OrderedTable[int, array[14, int]]

    for previousZ, previousValue in results.pairs:
      for input in countdown(9, 1):
        let newZ = runProgramOnce(input, previousZ, c1, c2, c3)

        if newZ > maxZValue:
          continue

        var newValue = previousValue
        newValue[i] = input
        newResults[newZ] = newValue

    results = newResults

  return results[0].join("")


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
