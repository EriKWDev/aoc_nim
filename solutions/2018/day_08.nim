import aoc


type
  Packet = ref object
    subPackets: seq[Packet]
    metadata: seq[int]


func `$`(packet: Packet): string =
  result &= "Packet("
  for packet in packet.subpackets: result &= $packet
  result &= ", " & $packet.metadata
  result &= ")"


func getData(input: string): seq[int] =
  for character in input.splitWhitespace():
    result &= parseInt($character)


func parsePackets(numbers: var Deque[int]): seq[Packet] =
  let
    newPacket = new(Packet)
    numberOfChildren = numbers.popFirst()
    numberOfMetadata = numbers.popFirst()

  for i in 1 .. numberOfChildren:
    newPacket.subPackets &= parsePackets(numbers)

  for i in 1 .. numberOfMetadata:
    newPacket.metadata &= numbers.popFirst()

  result &= newPacket


func sumMetadata(packets: openArray[Packet]): int =
  for packet in packets:
    result += packet.metadata.sum()
    result += packet.subPackets.sumMetadata()


func sumValues(packets: openArray[Packet]): int =
  for packet in packets:
    if len(packet.subPackets) == 0:
      result += packet.metadata.sum()
    else:
      var subPackets: seq[Packet]

      for metadata in packet.metadata:
        let index = metadata - 1
        if index < 0 or index > high(packet.subPackets):
          continue
        
        let subPacket = packet.subPackets[index]
        subPackets &= subPacket
      
      result += subPackets.sumValues()


func part1*(input: string): int =
  var numbers = getData(input).toDeque()

  let packets = parsePackets(numbers)
  return packets.sumMetadata()


func part2*(input: string): int =
  var numbers = getData(input).toDeque()

  let packets = parsePackets(numbers)
  return packets.sumValues()


const date* = (2018, 08)

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

