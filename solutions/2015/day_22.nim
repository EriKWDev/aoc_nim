import aoc


type
  Data = tuple
    hp: int
    damage: int
    mana: int


proc getData(input: string): Data =
  let values = input.split("\n").mapIt(parseInt(it.split(": ")[1]))
  return (values[0], values[1], 0)


proc part1*(input: string): auto =
  let monster = getData(input)
  var player: Data = (50, 0, 500)

  # echo monster
  return ""


proc part2*(input: string): auto =
  let data = getData(input)
  return ""


const date* = (2015, 22)

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
