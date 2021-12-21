import aoc


type
  Header = tuple
    version: int
    id: int

  Packet = object
    header: Header
    content: int
    subPackets: seq[Packet]


func `$`(packet: Packet): string =
  let
    header = packet.header
    content = packet.content
    subPackets = packet.subPackets

  return &"Packet({header=}, {content=}, {subPackets=})"


func getData(input: string): seq[int] =
  var binary = ""
  for character in input:
    binary &= toBin(fromHex[int]($character), 4)
  return binary.mapIt(if it == '0': 0 else: 1)


func readBits(data: var seq[int], n: int): string =
  result = data[0 ..< n].join("")
  data = data[n .. ^1]


func read(data: var seq[int], n: int): int =
  let value = readBits(data, n)
  return fromBin[int](value)


func parsePacketImpl(data: var seq[int]): Packet =
  let
    version = read(data, 3)
    id = read(data, 3)

  var
    content = 0
    subPackets: seq[Packet]

  if id == 4:
    var value = ""
    while true:
      let done = data[0] == 0

      data = data[1 .. ^1]
      value &= readBits(data, 4)

      if done: break

    content = fromBin[int](value)
  else:
    let lengthId = data[0]
    data = data[1 .. ^1]

    if lengthId == 1:
      for _ in 1 .. read(data, 11):
        subPackets.add(parsePacketImpl(data))

    else:
      let
        bitLenght = read(data, 15)
        length = len(data) - bitLenght

      while len(data) != length:
        subPackets.add(parsePacketImpl(data))

  return Packet(header: (version, id), content: content, subPackets: subPackets)


func parsePacket(data: seq[int]): Packet =
  var mutableData = data.deepCopy()
  return parsePacketImpl(mutableData)


func countVersion(packet: Packet): int =
  packet.header.version + sum(packet.subPackets.mapIt(countVersion(it)))


func evaluate(packet: Packet): int =
  case packet.header.id:
    of 0: result = sum(packet.subPackets.mapIt(evaluate(it)))
    of 1: result = prod(packet.subPackets.mapIt(evaluate(it)))
    of 2: result = min(packet.subPackets.mapIt(evaluate(it)))
    of 3: result = max(packet.subPackets.mapIt(evaluate(it)))
    of 4: result = packet.content

    of 5:
      assert len(packet.subPackets) == 2
      let (a, b) = (evaluate(packet.subPackets[0]), evaluate(packet.subPackets[1]))
      result = if a > b: 1 else: 0
    of 6:
      assert len(packet.subPackets) == 2
      let (a, b) = (evaluate(packet.subPackets[0]), evaluate(packet.subPackets[1]))
      result = if a < b: 1 else: 0
    of 7:
      assert len(packet.subPackets) == 2
      let (a, b) = (evaluate(packet.subPackets[0]), evaluate(packet.subPackets[1]))
      result = if a == b: 1 else: 0

    else: discard


func part1*(input: string): int =
  let
    data = getData(input)
    mainPacket = parsePacket(data)

  return countVersion(mainPacket)


func part2*(input: string): int =
  let
    data = getData(input)
    mainPacket = parsePacket(data)

  return evaluate(mainPacket)


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
  # submit2(date, answer2)


when isMainModule:
  main()
