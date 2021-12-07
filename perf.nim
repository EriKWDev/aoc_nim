import strformat, macros, os, strutils, std/monotimes, times, tables, aoc


const
  n = 1000
  maxDuration = initDuration(seconds = 10)
  solutionsFolder = "solutions"

type
  Result* = tuple
    name: string
    totalDuration: Duration
    times: int


func `$`*(res: Result): string =
  let
    nanoseconds = res.totalDuration.inNanoseconds()
    milliseconds = nanoseconds.float / 1000000.0
    ms = milliseconds / res.times.float
    s = if res.times > 0: "s" else: ""

  return &"{res.name:.<40}{ms:.3f} ms (Ran {res.times} time{s})"


proc measure*(part: proc(input: string): int|string, input, name: string): Result =
  var
    totalDuration: Duration
    times = 0

  for i in 1 .. n:
    let startTime = getMonoTime()
    discard part(input)
    let endTime = getMonoTime()
    inc times

    totalDuration += endTime - startTime

    if totalDuration > maxDuration:
      break

  return (name, totalDuration, times)


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

  var mainProcContent = newStmtList()

  var resultsIdent = ident("results")

  mainProcContent.add quote do:
    var `resultsIdent`: seq[Result]

  for year, moduleNames in moduleNamesByYear:
    for moduleName in moduleNames:
      let
        moduleIdent = ident(moduleName)
        day = moduleName[^2..^1]
        solutionName = &"{year}_{day}"

      mainProcContent.add quote do:
        let input = fetchInput((parseInt(`year`), parseInt(`day`)))

        `resultsIdent`.add measure(`moduleIdent`.part1, input, `solutionName` & " part 1")
        `resultsIdent`.add measure(`moduleIdent`.part2, input, `solutionName` & " part 2")

  result.add quote do:
    proc main() =
      `mainProcContent`

      for result in `resultsIdent`:
        echo result

    when isMainModule:
      main()

importSolutions()
