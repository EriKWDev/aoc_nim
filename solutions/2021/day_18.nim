import aoc


type SFNumber = ref object
  left: SFNumber
  right: SFNumber
  number: int


func newSFNumber(number: int): SFNumber =
  new(result)
  result.number = number


func newSFNumber(left, right: SFNumber): SFNumber =
  new(result)
  result.left = left
  result.right = right


func `$`(sfnumber: SFNumber): string =
  if sfnumber == nil:
    return ""

  if sfnumber.left == nil:
    return $sfnumber.number

  return &"%[{sfnumber.left}, {sfnumber.right}]"


const nonNumbers = {'[', ',', ']'}

func parseSFNumerImpl(line: string, i: var int): SFNumber =
  let word = line.splitWhitespace().join("")

  if word[i] == '[':
    inc i
    let left = parseSFNumerImpl(word, i)
    inc i
    let right = parseSFNumerImpl(word, i)
    inc i
    return newSFNumber(left, right)
  else:
    var numberString = ""

    while word[i] notin nonNumbers:
      numberString &= word[i]
      inc i

    return newSFNumber(parseInt(numberString))


func parseSFNumber(word: string): SFNumber =
  var i = 0
  return parseSFNumerImpl(word, i)


func getData(input: string): seq[SFNumber] = input.split("\n").mapIt(parseSFNumber(it))


func trySplitImpl(sfnumber: SFNumber, done: var bool) =
  if done: return

  if sfnumber.left == nil and sfnumber.number >= 10:
    done = true
    sfnumber.left = newSFNumber(sfnumber.number div 2)
    sfnumber.right = newSFNumber(sfnumber.number - sfnumber.number div 2)

  elif sfnumber.left != nil:
    trySplitImpl(sfnumber.left, done)
    trySplitImpl(sfnumber.right, done)


func trySplit(sfnumber: SFNumber): bool = trySplitImpl(sfnumber, result)


func tryExplodeImpl(sfnumber: SFNumber, previous: var SFNumber, rightExploded: var int, explodedPlaced: var bool, depth: int = 0) =
  if explodedPlaced:
    return

  if depth == 4 and sfnumber.left != nil and rightExploded == -1:
    if previous != nil:
      previous.number += sfnumber.left.number

    rightExploded = sfnumber.right.number
    sfnumber.left = nil
    sfnumber.right = nil
    sfnumber.number = 0
    return

  if rightExploded == -1:
    if sfnumber.left == nil:
      previous = sfnumber

  else:
    if sfnumber.left == nil:
      sfnumber.number += rightExploded
      explodedPlaced = true

  if sfnumber.left != nil:
    tryExplodeImpl(sfnumber.left, previous, rightExploded, explodedPlaced, depth+1)
    tryExplodeImpl(sfnumber.right, previous, rightExploded, explodedPlaced, depth+1)


func tryExplode(sfnumber: SFNumber): bool =
  var
    explodedPlaced = false
    rightExploded = -1
    previous: SFNumber = nil

  tryExplodeImpl(sfnumber, previous, rightExploded, explodedPlaced)
  return rightExploded >= 0


func reduce(sfnumber: SFNumber) =
  var didExplode = tryExplode(sfnumber)
  while didExplode:
    didExplode = tryExplode(sfnumber)

  var didSplit = trySplit(sfnumber)
  if didSplit:
    sfnumber.reduce()


func add(sfnA, sfnB: SFNumber): SFNumber =
  result = newSFNumber(sfnA.deepCopy(), sfnB.deepCopy())
  result.reduce()


func magnitude(sfnumber: SFNumber): int =
  if sfnumber.left == nil:
    return sfnumber.number

  return 3 * magnitude(sfnumber.left) + 2 * magnitude(sfnumber.right)


proc part1*(input: string): int =
  let sfnumbers = getData(input)

  var resultingSFNumber = sfnumbers[0]
  for i in 1 .. high(sfnumbers):
    resultingSFNumber = add(resultingSFNumber, sfnumbers[i])

  return magnitude(resultingSFNumber)


proc part2*(input: string): int =
  let sfnumbers = getData(input)

  for i, a in sfnumbers:
    for j, b in sfnumbers:
      if i == j: continue

      result = max(result, magnitude(add(a, b)))


const date* = (2021, 18)

proc main*() =
  doAssert magnitude(parseSFNumber("[[9,1],[1,9]]")) == 129
  doAssert magnitude(parseSFNumber("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")) == 1384
  doAssert magnitude(parseSFNumber("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")) == 3488

  var a, b, c, d, e: SFNumber

  a = parseSFNumber("[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]")
  b = parseSFNumber("[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]")
  doAssert $add(a, b) == $parseSFNumber("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]")

  a = parseSFNumber("[1,1]")
  b = parseSFNumber("[2,2]")
  c = parseSFNumber("[3,3]")
  d = parseSFNumber("[4,4]")
  e = parseSFNumber("[5,5]")

  let
    r1 = add(a, b)
    r2 = add(r1, c)
    r3 = add(r2, d)
    r4 = add(r3, e)

  doAssert $r4 == $parseSFNumber("[[[[3,0],[5,3]],[4,4]],[5,5]]")


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
