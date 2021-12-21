import aoc


type
  Data = tuple
    hp: int
    damage: int
    armor: int


func getData(input: string): Data =
  let data = input.splitLines().mapIt(parseInt(it.split(": ")[1]))

  return (data[0], data[1], data[2])


const
  weapons = [(8, 4, 0, "Dagger"),
             (10, 5, 0, "Shortsword"),
             (25, 6, 0, "Warhammer"),
             (40, 7, 0, "Longsword"),
             (74, 8, 0, "Greataxe")]

  armors = [(0, 0, 0, "None"),
            (13, 0, 1, "Leather"),
            (31, 0, 2, "Chainmail"),
            (53, 0, 3, "Splintmail"),
            (75, 0, 4, "Bandedmail"),
            (102, 0, 5, "Platemail")]

  rings = [(0, 0, 0, "None"),
           (0, 0, 0, "None"),
           (25, 1, 0, "Damage +1"),
           (50, 2, 0, "Damage +2"),
           (100, 3, 0, "Damage +3"),
           (20, 0, 1, "Defense +1"),
           (40, 0, 2, "Defense +2"),
           (80, 0, 3, "Defense +3")]


func battle(player: var Data, monster: var Data): auto =
  var rounds = 0

  while player.hp > 0 and monster.hp > 0:
    monster.hp -= max((player.damage - monster.armor), 1)
    if monster.hp > 0:
      player.hp -= max((monster.damage - player.armor), 1)
    inc rounds

  return (rounds: rounds, playerWon: player.hp > 0)


iterator allEquipment(): auto =
  for weapon in weapons:
    for armor in armors:
      for i, ring1 in rings:
        for ring2 in rings[i + 1 .. ^1]:
          yield [ring1, ring2, weapon, armor]


proc part1*(input: string): int =
  let monster: Data = getData(input)

  if isExample:
    var
      player = (8, 5, 5)
      theMonster = monster.deepCopy()

    return player.battle(theMonster).rounds

  result = int.high
  for equipment in allEquipment():
    let
      cost = equipment.mapIt(it[0]).sum()
      extraDamage = equipment.mapIt(it[1]).sum()
      extraArmor = equipment.mapIt(it[2]).sum()

    var
      player: Data = (100, extraDamage, extraArmor)
      monsterCopy = monster.deepCopy()

    let battleResult = player.battle(monsterCopy)

    if battleResult.playerWon:
      result = min(result, cost)


func part2*(input: string): auto =
  let monster: Data = getData(input)

  result = 0
  for equipment in allEquipment():
    let
      cost = equipment.mapIt(it[0]).sum()
      extraDamage = equipment.mapIt(it[1]).sum()
      extraArmor = equipment.mapIt(it[2]).sum()

    var
      player: Data = (100, extraDamage, extraArmor)
      monsterCopy = monster.deepCopy()

    let battleResult = player.battle(monsterCopy)

    if not battleResult.playerWon:
      result = max(result, cost)


const date* = (2015, 21)

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
