import aoc


type
  Data = tuple
    value1: seq[string]
    value2: seq[string]


proc getData(input: string): auto =
  var lines = input.split("\n")
  result = newSeq[Data]()
  for line in lines:
    var
      values = line.split("|")[0..1]
      first = values[0]
      second = values[1]

    var
      firstList = first.strip().split(" ")
      secondList = second.strip().split(" ")

    result.add((firstList, secondList))

const segments = [
  6, # 0
  2, # 1
  5, # 2
  5, # 3
  4, # 4
  5, # 5
  6, # 6
  3, # 7
  7, # 8
  6, # 9
]

const interestingIndexes = [1, 4, 7, 8]


proc part1*(input: string): auto =
  let data = getData(input)

  var score = 0

  for dataPoint in data:
    for value in dataPoint.value2:
      for interestingIndex in interestingIndexes:
        if len(value) == segments[interestingIndex]:
          inc score

  return score


import algorithm

proc part2*(input: string): auto =
  let data = getData(input)

  const letters = "abcdefg"
  const initialTable: Table[string, int] = {"acedgfb": 8, "cdfbe": 5, "gcdfa": 2, "fbcad": 3, "dab": 7,
         "cefabd": 9, "cdfgeb": 6, "eafb": 4, "cagedb": 0, "ab": 1}.toTable()

  var correctTable: Table[string, int]

  for key in initialTable.keys:
    correctTable[sorted(key).join()] = initialTable[key]

  var characters: seq[char]
  for character in letters:
    characters.add(character)

  var score = 0

  for dataPoint in data:
    for permutation in permutations(characters):

      var permutationMap: Table[char, char]

      for i, character in permutation:
        permutationMap[character] = letters[i]

      var newValue1: seq[string]
      for value1 in dataPoint.value1:
        var characters: seq[char]
        for character in value1:
          characters.add(permutationMap[character])

        newValue1.add(sorted(characters).join())

      var all = true
      for value in newValue1:
        if value notin correctTable:
          all = false
          break

      if all:
        var newValue2: seq[string]
        for value2 in dataPoint.value2:
          var characters: seq[char]
          for character in value2:
            characters.add(permutationMap[character])

          newValue2.add(sorted(characters).join())

        var output = ""
        for value in newValue2:
          output &= $correctTable[value]
        score += parseInt(output)

  return score


const date* = (2021, 8)

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
