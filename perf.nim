import strformat, macros, os, strutils, std/monotimes, times, tables, algorithm, json, hashes, aoc

const
  n = 1000
  maxDuration = initDuration(seconds = 10)
  solutionsFolder = "solutions"


type
  Result* = tuple
    name: string
    totalDuration: Duration
    times: int
    ms: float
    year: int
    hash: int


func `$`*(res: Result): string =
  let s = if res.times == 1: "" else: "s"

  return &"{res.name:.<35}{res.ms:.3f} ms (Ran {res.times} time{s})"


func toJson(res: Result): JsonNode =
  %* {
    "name": res.name,
    "totalDuration": res.totalDuration.inNanoseconds(),
    "times": res.times,
    "ms": res.ms,
    "year": res.year,
    "hash": res.hash
  }


func toResult(node: JsonNode): Result =
  let
    name = node["name"].getStr()
    totalDuration = initDuration(nanoseconds = node["totalDuration"].getInt())
    times = node["times"].getInt()
    ms = node["ms"].getFloat()
    year = node["year"].getInt()
    hash = node["hash"].getInt()

  return (name, totalDuration, times, ms, year, hash)


const resultsFilename = "results.json"

proc measure*(part: proc(input: string): int|string, input, name: string, year, hash: int): Result =
  var
    totalDuration: Duration
    times = 0

  echo &"Measuring {name}..."

  for i in 1 .. n:
    let startTime = getMonoTime()
    let res = part(input)
    let endTime = getMonoTime()
    inc times

    if i == 1 and isNullAnswer(res):
      return (name & " (skipped)", initDuration(seconds = 0), 0, 0.0, year, hash)

    totalDuration += endTime - startTime

    if totalDuration > maxDuration:
      break

  let
    nanoseconds = totalDuration.inNanoseconds()
    milliseconds = nanoseconds.float / 1000000.0
    ms = milliseconds / times.float

  result = (name, totalDuration, times, ms, year, hash)


macro importSolutions() =
  var
    allModuleNames: seq[string]
    moduleNamesByYear: Table[string, seq[tuple[name: string, hash: int]]]

  result = newStmtList()

  for file in os.walkDirRec(solutionsFolder):
    if file.contains("template"): continue

    let
      dirNameExt = file.splitFile()
      day = dirNameExt.name.split("_")[1]
      year = dirNameExt.dir.splitFile().name
      nameString = &"solution{year}{day}"
      name = ident(nameString)

    if year notin moduleNamesByYear:
      moduleNamesByYear[year] = @[]

    moduleNamesByYear[year].add((nameString, hash(staticRead(file))))
    allModuleNames.add(nameString)

    result.add quote do:
      import `file` as `name`

  var
    mainProcContent = newStmtList()
    resultsIdent = ident("results")
    jsonDataIdent = ident("jsonData")

  mainProcContent.add quote do:
    let `jsonDataIdent` = parseJson(readFile(resultsFilename))
    var `resultsIdent`: Table[string, seq[Result]]

  for (year, modules) in moduleNamesByYear.pairs:
    for module in modules:
      let moduleIdent = ident(module.name)

      mainProcContent.add quote do:
        let
          dayName = dateToName(`moduleIdent`.date)
          names = @[dayName & " part 1", dayName & " part 2"]

        for name in names:
          let inJson = `jsonDataIdent`.contains(name)

          var hasNewHash = false
          if inJson:
            hasNewHash = `jsonDataIdent`[name]{"hash"}.getInt(0) != `module`.hash

          var forceRunAll = false
          when defined(all):
            forceRunAll = true

          var shouldRun = forceRunAll or (not inJson) or hasNewHash

          var res: Result
          if shouldRun:
            let input = fetchInput(`moduleIdent`.date)

            res = measure(`moduleIdent`.part1, input, name, parseInt(`year`), `module`.hash)

            `jsonDataIdent`{name} = res.toJson()
          else:
            let data = jsonData[name]
            res = data.toResult()

          if `year` notin `resultsIdent`:
            `resultsIdent`[`year`] = @[]

          `resultsIdent`[`year`].add(res)

  result.add quote do:
    proc main() =
      `mainProcContent`

      let years = `resultsIdent`.keys.toSeq().sorted()

      for year in years:
        echo "\nPerformance for ", year, " by date and part"
        for result in `resultsIdent`[year].sortedByIt(it.name):
          echo result

        # echo "\nPerformance for ", year, " by speed"
        # for result in `resultsIdent`[year].sortedByIt(it.ms):
        #   echo result

        echo ""

      writeFile(resultsFilename, pretty(`jsonDataIdent`))


    when isMainModule:
      main()

importSolutions()
