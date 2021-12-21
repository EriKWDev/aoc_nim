
import strformat, regex, sequtils, strutils, tables, sets, intsets, htmlparser, xmltree, httpclient,
    os, json, math, hashes, algorithm, deques
export strformat, regex, sequtils, strutils, tables, sets, intsets, math, algorithm, deques

type
  Date* = tuple
    year: int
    day: int

  Example* = tuple
    name: string
    part1Answer: string
    part2Answer: string
    input: string

var isExample* = false


proc getSession(): string =
  var session = getEnv("AOC_SESSION")

  if session == "" and fileExists("env.json"):
    let
      fileContent = readFile("env.json")
      fileJson = parseJson(fileContent)
    session = fileJson["sessions"].getElems()[0].getStr("")

  return session


func dateToName*(date: Date): string = &"{date.year}_{date.day:02}"


proc ensureYearFolderExists(date: Date): string =
  let inputFolder = "input"
  discard existsOrCreateDir(inputFolder)

  let yearFolder = joinPath(inputFolder, $date.year)
  discard existsOrCreateDir(yearFolder)

  return yearFolder


proc ensureExamplesFolderExists(date: Date): string =
  let
    yearFolder = ensureYearFolderExists(date)
    dayFolder = joinPath(yearFolder, &"{date.day:02}")

  discard existsOrCreateDir(dayFolder)

  return dayFolder


proc ensureAutoFolderExists(date: Date): string =
  let
    yearFolder = ensureYearFolderExists(date)
    autoFolder = joinPath(yearFolder, "auto")

  discard existsOrCreateDir(autoFolder)

  return autoFolder


proc fetchCachedInput(date: Date): string =
  let autoFolder = ensureAutoFolderExists(date)

  var sessionHash: Hash = 0
  sessionHash = sessionHash !& hash(getSession())

  let inputFilename = joinPath(autoFolder, &"{dateToName(date)}_{!$sessionHash}.txt")
  if not fileExists(inputFilename):
    writeFile(inputFilename, "")
    return ""

  return readFile(inputFilename)


proc fetchInputFromAOC(date: Date): string =
  echo &"INFO: Fetching input for {date.year}, {date.day:2}..."

  let
    session = getSession()
    client = newHttpClient()

  client.headers.add("Cookie", &"session={session}")

  let
    url = &"https://adventofcode.com/{date.year}/day/{date.day}/input"
    res = client.get(url)

  if res.status[0] != '2':
    raise newException(Exception, &"Fetching input responded with status '{res.status}' ({url})")

  result = res.body.strip()
  echo result


proc writeInputToCache(date: Date, content: string) =
  let autoFolder = ensureAutoFolderExists(date)

  var sessionHash: Hash = 0
  sessionHash = sessionHash !& hash(getSession())

  let inputFilename = joinPath(autoFolder, &"{dateToName(date)}_{!$sessionHash}.txt")
  writeFile(inputFilename, content)


proc fetchInput*(date: Date): string =
  discard ensureExamplesFolderExists(date) # So that we can read and paste examples while input is fetching...
  let cachedInput = fetchCachedInput(date)

  if cachedInput != "":
    return cachedInput

  result = fetchInputFromAOC(date)
  writeInputToCache(date, result)


proc submit*(date: Date, answer: int|string, part: int) =
  if $answer == "":
    raise newException(ValueError, "Don't submit empty answers.")

  if part notin 1..2:
    raise newException(ValueError, &"Part '{part}' is not valid. Please make part either '1' or '2'")

  let
    session = getSession()
    client = newHttpClient()

  client.headers.add("Cookie", &"session={session}")
  client.headers.add("Content-Type", "application/x-www-form-urlencoded")

  echo &"INFO: Submitting answer '{answer}' for {date.year} {date.day:02} part {part}..."

  let
    url = &"https://adventofcode.com/{date.year}/day/{date.day}/answer"
    body = &"level={part}&answer={answer}"
    res = client.post(url, body = body)

  if res.status[0] != '2':
    raise newException(Exception, &"Submission responded with status '{res.status}'")

  let
    html = parseHtml(res.body)
    articles = html.findAll("article")

  if len(articles) < 1:
    let body = html.findall("body")[0].innerText
    echo &"> {body}\n"
    return

  let
    article = articles[0]
    message = article.innerText

  echo &"> {message}\n"


proc submit1*(date: Date, answer: int|string) =
  submit(date, answer, 1)


proc submit2*(date: Date, answer: int|string) =
  submit(date, answer, 2)


proc isNullAnswer*(answer: string|int): bool =
  when answer is int:
    if answer == 0: return false
  else:
    return answer == "" or answer == "null" or answer == "nil" or answer == "none"


proc getExamples(date: Date): seq[Example] =
  let examplesFolder = ensureExamplesFolderExists(date)

  proc getFilename(n: int): string = joinPath(examplesFolder, &"example_{n:02}.txt")

  var i = 1
  for file in walkDir(examplesFolder):
    var isExample = false

    if file.kind == pcFile:
      let
        content = readFile(file.path)
        lines = content.splitLines()
        name = file.path.splitFile().name

      if len(lines) == 0: continue

      var part1Answer: string = ""
      if not isNullAnswer(lines[0]):
        part1Answer = lines[0]
        isExample = true

      var part2Answer: string = ""
      if not isNullAnswer(lines[1]):
        part2Answer = lines[1]
        isExample = true

      if isExample:
        let input = lines[2 .. ^1].join("\n").strip()
        result.add((name, part1Answer, part2Answer, input))
        inc i

  var filename = getFilename(i)
  while not fileExists(filename):
    writeFile(filename, "null\nnull\n\n")
    filename = getFilename(i)
    inc i


proc runExamples*(date: Date, solver: proc(input: string): int|string,
    part: int): bool {.discardable.} =
  echo &"\n=== Examples {date.year} {date.day:02}, Part {part} ==="

  let examples = getExamples(date)
  result = true

  var
    succeeded = 0
    skipped = 0

  for example in examples.sortedByIt(it.name):
    isExample = true
    let answer = $solver(example.input)
    isExample = false

    let correctAnswer = if part == 1: example.part1Answer else: example.part2Answer

    if isNullAnswer(answer):
      echo &"{example.name} part {part}: SKIP: Received null answer"
      inc skipped
      continue

    if isNullAnswer(correctAnswer):
      echo &"{example.name} part {part}: SKIP: No answer provided in file"
      inc skipped
      continue

    if answer == correctAnswer:
      echo &"{example.name} part {part}: OK: {answer}"
      inc succeeded
      continue

    echo &"{example.name} part {part}: ERROR: expected {correctAnswer}, got {answer}"
    result = false

  echo &"\nSucceeded: {succeeded}/{len(examples) - skipped} (Skipped: {skipped})"
  echo "================================"


proc runExamples1*(date: Date, solver: proc(input: string): int|string): bool {.discardable.} =
  return runExamples(date, solver, 1)


proc runExamples2*(date: Date, solver: proc(input: string): int|string): bool {.discardable.} =
  return runExamples(date, solver, 2)


proc printAnswer*(answer: int|string) =
  echo &"\nAnswer: {answer}\n"


iterator combinations*[T](a: openarray[T], n: int): seq[T] =
  var
    chosen = newSeqOfCap[T](n)
    i = 0
    iStack = newSeqOfCap[int](n)

  while true:
    if chosen.len == n:
      yield chosen
      discard chosen.pop()
      i = iStack.pop() + 1
    elif i != a.len:
      chosen.add(a[i])
      iStack.add(i)
      inc i
    elif iStack.len > 0:
      discard chosen.pop()
      i = iStack.pop() + 1
    else:
      break


iterator allCombinations*[T](a: openarray[T]): seq[T] =
  for i in 1 .. len(a):
    for combination in combinations(a, i):
      yield combination


iterator permutations*[T](a: openarray[T]): seq[T] =
  var
    d = 1
    c = newSeq[int](a.len)
    xs = newSeq[T](a.len)

  for i, y in a: xs[i] = y
  yield xs

  block outer:
    while true:
      while d > 1:
        dec d
        c[d] = 0

      while c[d] >= d:
        inc d
        if d >= a.len:
          break outer

      let i = if (d and 1) == 1: c[d] else: 0
      swap xs[i], xs[d]
      yield xs
      inc c[d]
