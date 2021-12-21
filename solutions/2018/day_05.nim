import aoc


const
  letters = "abcdefghijklmnopqrstuvwxyz"
  pairs1 = letters.mapIt(it.toLowerAscii() & it.toUpperAscii())
  pairs2 = letters.mapIt(it.toUpperAscii() & it.toLowerAscii())
  pairs = (pairs1 & pairs2).toHashSet()


func reduce(input: string): string =
  var
    word: array[19000, char]
    index = 0

  for letter in input:
    if index > 0:
      let
        prev = word[index - 1]
        p1 = letter & prev
        p2 = prev & letter

      if p1 in pairs or p2 in pairs:
        dec index
        continue

    word[index] = letter
    inc index

  word[0 ..< index].join()


func part1*(input: string): int =
  reduce(input).len()


func part2*(input: string): int =
  result = int.high
  for l in letters:
    var newInput = input.replace($l.toUpperAscii(), "").replace($l.toLowerAscii(), "")
    result = min(result, reduce(newInput).len())


const date* = (2018, 5)

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
