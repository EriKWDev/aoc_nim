import aoc


type Entry = tuple[_: bool, year, month, day, hour, minute: int, rest: string]


func `$`(entry: Entry): string =
  let (_, year, month, day, hour, minute, rest) = entry
  result = &"[{year}-{month:02}-{day:02} {hour:02}:{minute:02}] {rest}"


func getData(input: string): seq[Entry] =
  input.splitLines().mapIt(it.scanTuple("[$i-$i-$i $i:$i] $+")).sortedByIt((it[1], it[2], it[3], it[4], it[5]))



func toMinutes(entry: Entry): int =
  let (_, year, month, day, hour, minute, _) = entry
  return year * 525600 + month * 43800 + day * 1440 + hour * 60 + minute


func calculateSchedule(entries: seq[Entry]): Table[int, array[0..59, int]] =
  var
    currentGuard = -1
    startEntry: Entry
    endEntry: Entry

  for entry in entries:
    let (ok1, id) = entry.rest.scanTuple("Guard #$i begins shift")
    if ok1:
      currentGuard = id

      if currentGuard notin result:
        var value: array[0..59, int]
        result[currentGuard] = value

      continue

    let ok2 = entry.rest.contains("falls asleep")
    if ok2:
      startEntry = entry
      continue

    let ok3 = entry.rest.contains("wakes up")
    if ok3:
      endEntry = entry

      let (m1, m2) = (startEntry.minute, endEntry.minute)
      for i in min(m1, m2) ..< max(m1, m2):
        inc result[currentGuard][i]


proc part1*(input: string): int =
  let
    entries = getData(input)
    schedule = calculateSchedule(entries)

  var mostMinutes = 0
  for guard in schedule.pairs:
    let
      (id, minutes) = guard

    #   minutesStrings = minutes.mapIt(if it == 0: " " else: "#")
    # echo &"#{id:5}: {minutesStrings.join()}"

    let n = minutes.sum()
    if n > mostMinutes:
      mostMinutes = n
      result = id * maxIndex(minutes)


proc part2*(input: string): auto =
  let
    entries = getData(input)
    schedule = calculateSchedule(entries)

  var maxMinutes = 0
  for (id, minutes) in schedule.pairs:
    let
      index = maxIndex(minutes)
      n = minutes[index]

    if n > maxMinutes:
      maxMinutes = n
      result = id * index


const date* = (2018, 4)

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
