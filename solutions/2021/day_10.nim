import aoc


func getData(input: string): seq[string] = input.splitLines()


const lookUp = {
  '(': ')',
  '[': ']',
  '{': '}',
  '<': '>',
}.toTable()

const keys = lookUp.keys.toSeq().toHashSet()


func part1*(input: string): int =
  let data = getData(input)

  const scores = {
    ')': 3,
    ']': 57,
    '}': 1197,
    '>': 25137,
  }.toTable()

  var counts = {
    ')': 0,
    ']': 0,
    '}': 0,
    '>': 0,
  }.toTable()

  for line in data:
    var values: Deque[char]

    for character in line:
      if character in keys:
        values.addFirst(character)
      else:
        var current = values.popFirst()

        if current notin keys or (current in keys and lookUp[current] != character):
          inc counts[character]

  for key in counts.keys:
    result += counts[key] * scores[key]


func part2*(input: string): int =
  let data = getData(input)

  const scores = {
    ')': 1,
    ']': 2,
    '}': 3,
    '>': 4,
  }.toTable()

  var finalScores: seq[int]

  for line in data:
    var
      values: Deque[char]
      isIncomplete = true

    for character in line:

      if character in keys:
        values.addFirst(character)
      else:
        var current = values.popFirst()

        if lookUp[current] != character:
          isIncomplete = false
          break

    if isIncomplete:
      var
        myScore = 0
        solution = ""

      for opening in values:
        myScore *= 5
        myScore += scores[lookUp[opening]]
        solution &= $lookUp[opening]

      finalScores.add(myScore)

  let finalIndex: int = ((len(finalScores) - 1) / 2).int
  finalScores.sort()

  return finalScores[finalIndex]


const date* = (2021, 10)

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
