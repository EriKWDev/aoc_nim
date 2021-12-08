import aoc


proc getData(input: string): auto =
  let numbersPattern = re"(?m)(-?\d+)"
  return input.findAll(numbersPattern).mapIt(parseInt(it.group(0, input)[0]))


proc part1*(input: string): auto =
  let numbers = getData(input)

  var
    score = 0
    previous = -1

  for number in numbers:
    if previous != -1 and number > previous:
      inc score
    previous = number


  return score


proc part2*(input: string): auto =
  let numbers = getData(input)

  var
    score = 0
    previous = -1

  for i in 2 .. high(numbers):
    let value = sum(numbers[(i-2) .. i])

    if previous != -1 and value > previous:
      inc score

    previous = value

  return score


const date* = (2021, 1)

proc main() =
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