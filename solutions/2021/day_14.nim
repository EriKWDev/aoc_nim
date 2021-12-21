import aoc


func getData(input: string): (string, Table[string, string]) =
  let
    chunks = input.split("\n\n")
    word = chunks[0].strip()

  var insertionMap: Table[string, string]

  for line in chunks[1].split("\n"):
    let splitted = line.split(" -> ")
    insertionMap[splitted[0].strip()] = splitted[1].strip()

  return (word, insertionMap)


func applyInsertion(word: string, map: Table[string, string]): string =
  var
    insertions: seq[(string, int)]
    newWord = word
    offset = 1

  for i in 0 ..< high(newWord):
    let current = newWord[i .. i+1]

    if current in map:
      insertions.add((map[current], i + offset))
      inc offset

  for (insertion, position) in insertions:
    newWord.insert(insertion, position)

  return newWord


func applyInsertion2(pairCountMap: Table[string, int], insertionMap: Table[string, string], counts: var Table[string, int]): Table[string, int] =
  for pair in pairCountMap.keys:
    if pair in insertionMap:
      let
        value = insertionMap[pair]
        key1 = pair[0] & value
        key2 = value & pair[1]

      if value notin counts:
        counts[value] = 0

      counts[value] = counts[value] + pairCountMap[pair]

      for key in [key1, key2]:
        if key notin result:
          result[key] = 0

        result[key] += pairCountMap[pair]


func part1*(input: string): int =
  let (word, insertionMap) = getData(input)

  var theWord = word
  for i in 1 .. 10:
    theWord = theWord.applyInsertion(insertionMap)

  var counts: Table[string, int]

  for character in theWord:
    let key = $character
    if key notin counts:
      counts[key] = 0

    inc counts[key]

  let sortedValues = sorted(counts.values.toSeq())
  return sortedValues[^1] - sortedValues[0]


func part2*(input: string): int =
  let (word, insertionMap) = getData(input)

  var pairCountMap: Table[string, int]

  for i in 0 ..< high(word):
    let key = word[i..i+1]
    if key notin pairCountMap:
      pairCountMap[key] = 0
    inc pairCountMap[key]

  var counts: Table[string, int]

  for character in word:
    let key = $character
    if key notin counts:
      counts[key] = 0
    inc counts[key]

  for i in 1 .. 40:
    pairCountMap = applyInsertion2(pairCountMap, insertionMap, counts)

  let sortedValues = sorted(counts.values.toSeq())
  return sortedValues[^1] - sortedValues[0]


const date* = (2021, 14)

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
