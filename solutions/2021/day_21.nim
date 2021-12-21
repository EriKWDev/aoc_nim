import aoc


type Data = array[2, int]

proc getData(input: string): Data =
  let
    numbersPattern = re"(?m)(-?\d+)"
    numbers = input.findAll(numbersPattern).mapIt(parseInt(it.group(0, input)[0]))

  return [numbers[1], numbers[3]]


func part1*(input: string): int =
  var
    positions = getData(input)
    state = 1
    player = 1
    scores = [0, 0]
    times = 0

  proc die(n: int): int =
    for i in 1 .. n:
      result += state
      inc state
      inc times

  while max(scores) < 1000:
    player = (player + 1) mod 2

    let newPosition = ((positions[player] + die(3) - 1) mod 10) + 1

    positions[player] = newPosition
    scores[player] += newPosition

  return times * min(scores)


type Cache = Table[(int, int, int, int, int), Data]

proc diracDiceGameImpl(positions: Data, player: int, scores: Data, cache: var Cache): Data =
  if scores[0] >= 21: return [1, 0] elif scores[1] >= 21: return [0, 1]

  let key = (positions[0], positions[1], player, scores[0], scores[1])
  if key in cache:
    return cache[key]

  for die1 in 1 .. 3:
    for die2 in 1 .. 3:
      for die3 in 1 .. 3:
        let
          die = die1 + die2 + die3
          newPosition = ((positions[player] + die - 1) mod 10) + 1
          newPlayer = (player + 1) mod 2

        var
          newPositions = positions.deepCopy()
          newScores = scores.deepCopy()

        newPositions[player] = newPosition
        newScores[player] += newPosition

        let game = diracDiceGameImpl(newPositions, newPlayer, newScores, cache)
        result = [result[0] + game[0], result[1] + game[1]]

  cache[key] = result


proc diracDiceGame(positions: Data, player: int, scores: Data): Data =
  var cache: Cache
  return diracDiceGameImpl(positions, player, scores, cache)


proc part2*(input: string): auto =
  let
    positions = getData(input)
    player = 0
    scores = [0, 0]
    game = diracDiceGame(positions, player, scores)

  echo game

  return max(game)


const date* = (2021, 21)

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
