import strformat, macros, os, strutils, std/monotimes, times, tables, aoc, algorithm, json


const
  n = 1000
  maxDuration = initDuration(seconds = 10)
  solutionsFolder = "solutions"
  forceRunAll = false

type
  Result* = object
    name: string
    totalDuration: Duration
    times: int
    ms: float
    year: int

func `$`*(res: Result): string =
  let s = if res.times == 1: "" else: "s"

  return &"{res.name:.<30}{res.ms:.3f} ms (Ran {res.times} time{s})"


func toJson(res: Result): JsonNode =
  %* {
    "name": res.name,
    "totalDuration": res.totalDuration.inNanoseconds(),
    "times": res.times,
    "ms": res.ms,
    "year": res.year
  }

func toResult(node: JsonNode): Result =
  let
    name = node["name"].getStr()
    totalDuration = initDuration(nanoseconds = node["totalDuration"].getInt())
    times = node["times"].getInt()
    ms = node["ms"].getFloat()
    year = node["year"].getInt()

  return Result(name: name, totalDuration: totalDuration, times: times, ms: ms, year: year)

const resultsFilename = "results.json"

proc measure*(part: proc(input: string): int|string, input, name: string, year: int): Result =
  var
    totalDuration: Duration
    times = 0

  echo &"Measuring {name}..."

  for i in 1 .. n:
    let startTime = getMonoTime()
    discard part(input)
    let endTime = getMonoTime()
    inc times

    totalDuration += endTime - startTime

    if totalDuration > maxDuration:
      break

  let
    nanoseconds = totalDuration.inNanoseconds()
    milliseconds = nanoseconds.float / 1000000.0
    ms = milliseconds / times.float

  result = Result(name: name, totalDuration: totalDuration, times: times, ms: ms)


macro importSolutions() =
  var
    allModuleNames: seq[string]
    moduleNamesByYear: Table[string, seq[string]]

  result = newStmtList()

  for file in os.walkDirRec(solutionsFolder):
    if file.contains("template"): continue

    let
      dirNameExt = file.splitFile()
      day = dirNameExt.name.split("_")[1]
      year = dirNameExt.dir.splitFile().name
      nameString = &"solution{year}{day}"
      name = ident(nameString)

    allModuleNames.add(nameString)

    if year notin moduleNamesByYear:
      moduleNamesByYear[year] = @[]

    moduleNamesByYear[year].add(nameString)

    result.add quote do:
      import `file` as `name`

  var
    mainProcContent = newStmtList()
    resultsIdent = ident("results")
    jsonDataIdent = ident("jsonData")

  mainProcContent.add quote do:
    let `jsonDataIdent` = parseJson(readFile(resultsFilename))
    var `resultsIdent`: Table[string, seq[Result]]

  for year, moduleNames in moduleNamesByYear:
    for moduleName in moduleNames:
      let moduleIdent = ident(moduleName)

      mainProcContent.add quote do:
        let
          dayName = dateToName(`moduleIdent`.date)
          names = @[dayName & " part 1", dayName & " part 2"]

        for name in names:
          var res: Result
          if forceRunAll or not `jsonDataIdent`.contains(name):
            let input = fetchInput(`moduleIdent`.date)

            res = measure(`moduleIdent`.part1, input, name, parseInt(`year`))

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

      for year in `resultsIdent`.keys:
        echo "Performance for ", year, " by date and part"
        for result in `resultsIdent`[year].sortedByIt(it.name):
          echo result

        echo "\nPerformance for ", year, " by speed"
        for result in `resultsIdent`[year].sortedByIt(it.ms):
          echo result

        echo "\n"

      writeFile(resultsFilename, pretty(`jsonDataIdent`))


    when isMainModule:
      main()

importSolutions()
