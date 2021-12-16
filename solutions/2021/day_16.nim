import aoc


type
  Header = tuple
    version: int
    id: int

  Packet = object
    header: Header
    content: int
    subPackets: seq[Packet]

const parseTable: Table[char, string] = {
  '0': "0000",
  '1': "0001",
  '2': "0010",
  '3': "0011",
  '4': "0100",
  '5': "0101",
  '6': "0110",
  '7': "0111",
  '8': "1000",
  '9': "1001",
  'A': "1010",
  'B': "1011",
  'C': "1100",
  'D': "1101",
  'E': "1110",
  'F': "1111"
}.toTable()

func `$`(packet: Packet): string =
  let
    header = packet.header
    content = packet.content
    subPackets = packet.subPackets

  return &"Packet({header=}, {content=}, {subPackets=})"


func getData(input: string): string =
  for character in input:
    result &= parseTable[character]

func streamBinary(data: var string, n = -1): string =
  if n > 0:
    let highIndex = min(high(data), n)
    result = data[0 ..< highIndex]
    data =
      if highIndex == 0: ""
      else: data[highIndex .. ^1]
    return

  while data[0] == '1':
    let highIndex = min(high(data), 5)
    result &= data[1 .. highIndex]
    data = data[5 .. ^1]

  let highIndex = min(high(data), 5)
  result &= data[1 ..< highIndex]
  data =
    if highIndex == 0 or len(data) == 5: ""
    else: data[highIndex .. ^1]


const maxPacketSize = 80

func streamData(data: var string, n = -1): int =
  let shouldDebug = len(data) <= maxPacketSize
  if shouldDebug: debugEcho align(data, maxPacketSize)

  let value = streamBinary(data, n)
  if shouldDebug: debugEcho align(value, maxPacketSize - len(data))

  return fromBin[int](value)


proc streamParseDataImpl(data: var string): Packet =
  let
    version = streamData(data, 3)
    id = streamData(data, 3)
    header: Header = (version, id)

  var
    subPackets: seq[Packet]
    content: int

  if id == 4:
    content = streamData(data)
    debugEcho "CONTENT:", content
  else:
    let sizeKind = streamData(data, 1)

    if sizeKind == 0:
      let
        packetSizeBin = streamBinary(data, 15)
        packetSize = fromBin[int](packetSizeBin)
        packetsLength = len(data)

      while packetsLength - len(data) != packetSize:
        subPackets.add(streamParseDataImpl(data))

    else:
      let numberOfPackets = streamData(data, 11)

      for _ in 1 .. numberOfPackets:
        subPackets.add(streamParseDataImpl(data))

  return Packet(header: header, content: content, subPackets: subPackets)


proc streamParseData(data: string): Packet =
  var streamableData = data.deepCopy()
  return streamParseDataImpl(streamableData)


proc parsePackets(data: string, n: int = -1): seq[Packet] =
  let
    version = fromBin[int](data[0..2])
    id = fromBin[int](data[3..5])
    header: Header = (version, id)
    contentStart = 6

  case id:
    of 4:
      var
        location = contentStart
        contentString = ""

      while true:
        let indicator = data[location]
        contentString &= data[location + 1 .. location + 4]
        location += 5

        if indicator == '0':
          break

      let
        content = if contentString == "": 0 else: fromBin[int](contentString)
        packet = Packet(header: header, content: content)
        rest = data[location .. ^1]

      result.add(packet)
      if location < len(data) and fromBin[int](rest) != 0:
        result &= parsePackets(rest)

    else:
      var
        location = contentStart
        subPackets: seq[Packet]

      let
        lengthTypeId = data[location .. location]

      inc location

      case lengthTypeId:
        of "0":
          let
            lengthData = data[location ..< location + 15]
            packetLength = fromBin[int](lengthData)

          echo location, " .. ", location + 15, ": ", lengthData, " (", packetLength, ")"
          echo data
          echo align(lengthData, 15 + location)

          location += 15

          let subPacketsString = data[location ..< location + packetLength]
          subPackets = parsePackets(subPacketsString)

          echo align(subPacketsString, location + packetLength)

          location += packetLength

        of "1":
          let
            lengthData = data[location ..< location + 15]
            numberOfSubPackets = fromBin[int](lengthData)



          let subPacketsString = data[location .. ^1]
          subPackets = parsePackets(subPacketsString)

        else: discard

      let packet = Packet(header: header, content: 0, subPackets: subPackets)
      result.add(packet)

      let rest = data[location .. ^1]
      if location < len(data) and fromBin[int](rest) != 0:
        result &= parsePackets(rest)


func countVersion(packet: Packet): int =
  result = packet.header.version
  for subPacket in packet.subPackets:
    result += countVersion(subPacket)


func evaluate(packet: Packet): int =
  case packet.header.id:
    of 0: result = sum(packet.subPackets.mapIt(evaluate(it)))
    of 1:
      result = 1
      for subPacket in packet.subPackets:
        result *= subPacket.content

    of 2: result = min(packet.subPackets.mapIt(evaluate(it)))
    of 3: result = max(packet.subPackets.mapIt(evaluate(it)))
    of 4:
      result = packet.content
    of 5:
      assert len(packet.subPackets) == 2
      result =
        if evaluate(packet.subPackets[0]) > evaluate(packet.subPackets[1]):
          1
        else: 0

    of 6:
      assert len(packet.subPackets) == 2
      result =
        if evaluate(packet.subPackets[0]) < evaluate(packet.subPackets[1]):
          1
        else: 0

    of 7:
      assert len(packet.subPackets) == 2
      result =
        if evaluate(packet.subPackets[0]) == evaluate(packet.subPackets[1]):
          1
        else: 0

    else: discard


func part1*(input: string): auto =
  let
    data = getData(input)
    mainPacket = streamParseData(data)
  return countVersion(mainPacket)


proc part2*(input: string): auto =
  let
    data = getData(input)
    mainPacket = streamParseData(data)
    value = evaluate(mainPacket)

  doAssert value != 23038638993632

  return value


const date* = (2021, 16)

proc main*() =
  let input = fetchInput(date)

  if not runExamples1(date, part1): return
  let answer1 = part1(input)
  printAnswer(answer1)
  # submit1(date, answer1)

  if not runExamples2(date, part2): return
  let answer2 = part2(input)
  printAnswer(answer2)
  submit2(date, answer2)


when isMainModule:
  main()
