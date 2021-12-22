import aoc


type Data = tuple[_: bool, step, before: string]


func getData(input: string): seq[Data] =
  const pattern = "Step $w must be finished before step $w can begin."
  return input.splitLines().mapIt(it.scanTuple(pattern))


proc part1*(input: string): auto =
  let data = getData(input)
  # echo data
  return ""


proc part2*(input: string): auto =
  let data = getData(input)
  return ""


const date* = (2018, 7)

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
