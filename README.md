# About
These are my solutions to *Advent of Code*, written in Nim. During 2021 I began solving in dart (See my repo `aoc_dart`), but switched to Nim because I missed the amazing tuples.

## Performance
Please see `perf.nim` for how measurements are taken. Briefly, I use a macro to import every solution at compile time and generate statements that call `measure` on each part for each solution. Parts are measured either until they've been run 1000 times or until the total time exceeds 10 seconds. Time it takes to fetch and/or read the input is not included in the measurement (The parsing of the input within the solution still is counted of course).

I compile it with `nim c -d:danger -d:release --opt:speed --passC:'flto' -r perf.nim`

```
Performance for 2015 by date and part
2015_01 part 1.....................0.000 ms (Ran 1000 times)
2015_01 part 2.....................0.000 ms (Ran 1000 times)
2015_20 part 1.....................245.135 ms (Ran 41 times)
2015_20 part 2.....................250.048 ms (Ran 40 times)
2015_21 part 1.....................0.412 ms (Ran 1000 times)
2015_21 part 2.....................0.389 ms (Ran 1000 times)
2015_22 part 1 (skipped)...........0.000 ms (Ran 0 times)
2015_22 part 2 (skipped)...........0.000 ms (Ran 0 times)
2015_23 part 1.....................0.059 ms (Ran 1000 times)
2015_23 part 2.....................0.037 ms (Ran 1000 times)
2015_24 part 1 (skipped)...........0.000 ms (Ran 0 times)
2015_24 part 2 (skipped)...........0.000 ms (Ran 0 times)


Performance for 2019 by date and part
2019_10 part 1.....................61.487 ms (Ran 163 times)
2019_10 part 2.....................66.571 ms (Ran 151 times)


Performance for 2021 by date and part
2021_01 part 1.....................1.228 ms (Ran 1000 times)
2021_01 part 2.....................1.252 ms (Ran 1000 times)
2021_08 part 1.....................0.674 ms (Ran 1000 times)
2021_08 part 2.....................0.670 ms (Ran 1000 times)
2021_09 part 1.....................1.492 ms (Ran 1000 times)
2021_09 part 2.....................1.485 ms (Ran 1000 times)
2021_10 part 1.....................0.158 ms (Ran 1000 times)
2021_10 part 2.....................0.152 ms (Ran 1000 times)
2021_11 part 1.....................0.669 ms (Ran 1000 times)
2021_11 part 2.....................0.666 ms (Ran 1000 times)
2021_12 part 1.....................64.146 ms (Ran 156 times)
2021_12 part 2.....................62.076 ms (Ran 162 times)
2021_13 part 1.....................0.353 ms (Ran 1000 times)
2021_13 part 2.....................0.350 ms (Ran 1000 times)
2021_14 part 1.....................70.917 ms (Ran 142 times)
2021_14 part 2.....................73.685 ms (Ran 136 times)
2021_15 part 1.....................29.133 ms (Ran 344 times)
2021_15 part 2.....................30.156 ms (Ran 332 times)
2021_16 part 1.....................3.343 ms (Ran 1000 times)
2021_16 part 2.....................3.366 ms (Ran 1000 times)
2021_17 part 1.....................0.238 ms (Ran 1000 times)
2021_17 part 2.....................0.240 ms (Ran 1000 times)
2021_18 part 1.....................3.433 ms (Ran 1000 times)
2021_18 part 2.....................3.402 ms (Ran 1000 times)
2021_20 part 1.....................24.849 ms (Ran 403 times)
2021_20 part 2.....................24.464 ms (Ran 409 times)
2021_21 part 1.....................0.010 ms (Ran 1000 times)
2021_21 part 2.....................0.010 ms (Ran 1000 times)
```