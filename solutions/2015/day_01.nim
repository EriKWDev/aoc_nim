import aoc


proc part1*(input: string): auto =
  var score = 0

  for value in input:
    if value == '(':
      inc score
    else:
      dec score

  return score


proc part2*(input: string): auto =
  var score = 0

  for i, value in input:
    if value == '(':
      inc score
    else:
      dec score

    if score < 0:
      return i + 1

  return -1

const date* = (2015, 1)


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
