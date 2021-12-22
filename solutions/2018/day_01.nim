import aoc


func getData(input: string): seq[int] =
  return input.splitLines().map(parseInt)


func part1*(input: string): int =
  return getData(input).sum()


func part2*(input: string): int =
  let data = getData(input)

  var
    frequency = 0
    frequencies = [0].toIntSet()

  while true:
    for number in data:
      frequency += number

      if frequency in frequencies:
        return frequency

      frequencies.incl(frequency)


const date* = (2018, 1)

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
