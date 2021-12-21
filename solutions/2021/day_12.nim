import aoc


type Map = Table[string, HashSet[string]]


func getData(input: string): Map =
  for line in input.split("\n"):
    let sides = line.split("-")

    let
      key = sides[0]
      value = sides[1]

    if key notin result:
      result[key] = initHashSet[string]()

    result[key].incl(value)
    if value notin result:
      result[value] = initHashSet[string]()

    result[value].incl(key)


func isLowerCase(word: string): bool =
  result = true
  for character in word:
    if character.isUpperAscii():
      return false


func numberOfPaths(map: Map, current: string, visited: var HashSet[string]): int =
  if current == "end":
    return 1

  if current.isLowerCase():
    if current in visited:
      return 0

    visited.incl(current)

  for destination in map[current]:
    var newVisited: HashSet[string]
    newVisited.incl(visited)
    result += numberOfPaths(map, destination, newVisited)


func numberOfPaths2(map: Map, current: string, visited: var Table[string, int]): int =
  if current == "end":
    # echo visited
    return 1

  if current.isLowerCase():
    if current notin visited:
      visited[current] = 0

    visited[current] = visited[current] + 1

    if visited[current] > 2:
      return 0

    if current == "start" and visited["start"] >= 2:
      return 0

    var numberGreater = 0
    for (key, value) in visited.pairs:
      if key == "start": continue

      if value >= 2:
        inc numberGreater

        if numberGreater >= 2:
          return 0

  for destination in map[current]:
    var newVisited: Table[string, int]
    for key in visited.keys:
      newVisited[key] = visited[key]

    result += numberOfPaths2(map, destination, newVisited)


func part1*(input: string): int =
  let map = getData(input)

  var visited: HashSet[string]
  return numberOfPaths(map, "start", visited)


func part2*(input: string): auto =
  let map = getData(input)
  var visited: Table[string, int]
  return numberOfPaths2(map, "start", visited)


const date* = (2021, 12)

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
