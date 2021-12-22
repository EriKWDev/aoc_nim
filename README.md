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
2015_21 part 1.....................0.416 ms (Ran 1000 times)
2015_21 part 2.....................0.418 ms (Ran 1000 times)
2015_22 part 1 (skipped)...........0.000 ms (Ran 0 times)
2015_22 part 2 (skipped)...........0.000 ms (Ran 0 times)
2015_23 part 1.....................0.038 ms (Ran 1000 times)
2015_23 part 2.....................0.038 ms (Ran 1000 times)
2015_24 part 1 (skipped)...........0.000 ms (Ran 0 times)
2015_24 part 2 (skipped)...........0.000 ms (Ran 0 times)


Performance for 2018 by date and part
2018_01 part 1.....................0.078 ms (Ran 1000 times)
2018_01 part 2.....................0.077 ms (Ran 1000 times)
2018_02 part 1.....................0.257 ms (Ran 1000 times)
2018_02 part 2.....................0.253 ms (Ran 1000 times)
2018_03 part 1.....................44.033 ms (Ran 228 times)
2018_03 part 2.....................44.217 ms (Ran 227 times)
2018_04 part 1.....................3.431 ms (Ran 1000 times)
2018_04 part 2.....................3.439 ms (Ran 1000 times)
2018_05 part 1.....................4.813 ms (Ran 1000 times)
2018_05 part 2.....................4.955 ms (Ran 1000 times)
2018_06 part 1.....................10.173 ms (Ran 983 times)
2018_06 part 2.....................10.078 ms (Ran 993 times)
2018_07 part 1 (skipped)...........0.000 ms (Ran 0 times)
2018_07 part 2 (skipped)...........0.000 ms (Ran 0 times)


Performance for 2019 by date and part
2019_10 part 1.....................47.947 ms (Ran 209 times)
2019_10 part 2.....................48.070 ms (Ran 209 times)


Performance for 2021 by date and part
2021_01 part 1.....................1.228 ms (Ran 1000 times)
2021_01 part 2.....................1.252 ms (Ran 1000 times)
2021_08 part 1.....................0.701 ms (Ran 1000 times)
2021_08 part 2.....................0.706 ms (Ran 1000 times)
2021_09 part 1.....................1.526 ms (Ran 1000 times)
2021_09 part 2.....................1.524 ms (Ran 1000 times)
2021_10 part 1.....................0.156 ms (Ran 1000 times)
2021_10 part 2.....................0.155 ms (Ran 1000 times)
2021_11 part 1.....................0.678 ms (Ran 1000 times)
2021_11 part 2.....................0.671 ms (Ran 1000 times)
2021_12 part 1.....................71.694 ms (Ran 140 times)
2021_12 part 2.....................71.348 ms (Ran 141 times)
2021_13 part 1.....................0.376 ms (Ran 1000 times)
2021_13 part 2.....................0.378 ms (Ran 1000 times)
2021_14 part 1.....................80.869 ms (Ran 124 times)
2021_14 part 2.....................87.228 ms (Ran 115 times)
2021_15 part 1.....................26.647 ms (Ran 376 times)
2021_15 part 2.....................26.623 ms (Ran 376 times)
2021_16 part 1.....................3.343 ms (Ran 1000 times)
2021_16 part 2.....................3.366 ms (Ran 1000 times)
2021_17 part 1.....................0.238 ms (Ran 1000 times)
2021_17 part 2.....................0.240 ms (Ran 1000 times)
2021_18 part 1.....................3.545 ms (Ran 1000 times)
2021_18 part 2.....................3.538 ms (Ran 1000 times)
2021_20 part 1.....................26.601 ms (Ran 376 times)
2021_20 part 2.....................25.247 ms (Ran 397 times)
2021_21 part 1.....................0.010 ms (Ran 1000 times)
2021_21 part 2.....................0.010 ms (Ran 1000 times)
2021_22 part 1.....................20.788 ms (Ran 482 times)
2021_22 part 2.....................21.001 ms (Ran 477 times)
```