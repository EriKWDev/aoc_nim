import aoc


proc part1*(input: string): int =
  for value in input:
    if value == '(':
      inc result
    else:
      dec result


proc part2*(input: string): int =
  for i, value in input:
    if value == '(':
      inc result
    else:
      dec result

    if result < 0:
      return i + 1


const date* = (2015, 1)

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
