import aoc


type
  Data = tuple
    value1: string
    value2: int


proc getData(input: string): auto =
  return input.split("\n")
  # return input.split("\n\n")
  # return input.split(",")
  # return input.split("")

  #[
  let numbersPattern = re"(?m)(-?\d+)"
  return input.findAll(numbersPattern).mapIt(parseInt(it.group(0, input)[0]))
  ]#

  #[
  result = newSeq[Data]()
  let dataPattern = re"(?m)^(\w+):\D+(-?\d+)$"
  for m in input.findAll(dataPattern):
    result &= (m.group(0, input)[0], parseInt(m.group(1, input)[0]))
  ]#


proc part1*(input: string): auto =
  let data = getData(input)
  return ""


proc part2*(input: string): auto =
  let data = getData(input)
  return ""


const date = (2021, 7)

proc main() =
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
