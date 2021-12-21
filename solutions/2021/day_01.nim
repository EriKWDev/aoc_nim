import aoc


func getData(input: string): seq[int] =
  let numbersPattern = re"(?m)(-?\d+)"
  return input.findAll(numbersPattern).mapIt(parseInt(it.group(0, input)[0]))


func part1*(input: string): int =
  let numbers = getData(input)

  var previous = -1

  for number in numbers:
    if previous != -1 and number > previous:
      inc result
    previous = number


func part2*(input: string): int =
  let numbers = getData(input)

  var previous = -1

  for i in 2 .. high(numbers):
    let value = sum(numbers[(i-2) .. i])

    if previous != -1 and value > previous:
      inc result

    previous = value


const date* = (2021, 1)

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
