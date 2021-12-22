import aoc


func getData(input: string): seq[string] =
  return input.splitLines()


proc part1*(input: string): int =
  let tables = getData(input).mapIt(it.toSeq().toCountTable())

  var numbers = [0, 0]
  for table in tables:
    let values = table.values.toSeq().toIntSet()

    if 2 in values: inc numbers[0]
    if 3 in values: inc numbers[1]

  return numbers.prod()


proc part2*(input: string): string =
  let data = getData(input)

  for i, id1 in data[0 .. ^2]:
    for j, id2 in data[i+1 .. ^1]:
      var letters = ""
      for n in 0 .. high(id1):
        if id1[n] == id2[n]:
          letters &= id1[n]

      if len(letters) > len(result):
        result = letters


const date* = (2018, 2)

proc main*() =
  let input = fetchInput(date)

  if not runExamples1(date, part1): return
  let answer1 = part1(input)
  printAnswer(answer1)
  # submit1(date, answer1)

  if not runExamples2(date, part2): return
  let answer2 = part2(input)
  printAnswer(answer2)
  submit2(date, answer2)


when isMainModule:
  main()
