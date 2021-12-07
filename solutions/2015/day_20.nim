import aoc


proc getData(input: string): auto =
  return parseInt(input)


proc part1*(input: string): auto =
  const m = 10

  let
    number = getData(input)
    d = number div m

  var counts = newSeq[int](d)
  for i in 1 .. d:
    for j in 1 .. min(d div i, int.high):
      counts[j * i - 1] += i * m

    if counts[i - 1] >= number:
      return $i

  return ""


proc part2*(input: string): auto =
  const m = 11

  let
    number = getData(input)
    d = number div m

  var counts = newSeq[int](d)
  for i in 1 .. d:
    for j in 1 .. min(d div i, 50):
      counts[j * i - 1] += i * m

    if counts[i - 1] >= number:
      return $i

  return ""


const date = (2015, 20)

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
