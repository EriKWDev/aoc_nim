import aoc


type
  Instruction = tuple
    name: string
    register: string
    value: int


proc getData(input: string): seq[Instruction] =
  for line in input.split("\n"):
    let splitted = line.split(" ")

    if len(splitted) == 3:
      result &= (splitted[0], splitted[1][0..^2].join(""), parseInt(splitted[2]))
    else:
      if splitted[0] == "jmp":
        result &= (splitted[0], "", parseInt(splitted[1]))
      else:
        result &= (splitted[0], splitted[1], 0)


func execute(instructions: seq[Instruction], register: var Table[string, int], index: int = 0) =
  if index < 0 or index > high(instructions):
    return

  var offset = 1
  let instruction = instructions[index]

  case instruction.name:
    of "hlf":
      register[instruction.register] = register[instruction.register] div 2
    of "tpl":
      register[instruction.register] = register[instruction.register] * 3
    of "inc":
      inc register[instruction.register]
    of "jmp":
      offset = instruction.value
    of "jie":
      if register[instruction.register] mod 2 == 0:
        offset = instruction.value
    of "jio":
      if register[instruction.register] == 1:
        offset = instruction.value

  execute(instructions, register, index + offset)


proc part1*(input: string): auto =
  let instructions = getData(input)

  var register = {
    "a": 0,
    "b": 0
  }.toTable()

  execute(instructions, register)

  if isExample:
    return register["a"]

  return register["b"]


proc part2*(input: string): auto =
  let instructions = getData(input)

  var register = {
    "a": 1,
    "b": 0
  }.toTable()

  execute(instructions, register)

  return register["b"]


const date* = (2015, 23)

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
