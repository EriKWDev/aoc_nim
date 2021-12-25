# About
These are my solutions to *Advent of Code*, written in Nim. During 2021 I began solving in dart (See my repo `aoc_dart`), but switched to Nim because I missed the amazing tuples.

## Performance
Please see `perf.nim` for how measurements are taken. Briefly, I use a macro to import every solution at compile time and generate statements that call `measure` on each part for each solution. Parts are measured either until they've been run 1000 times or until the total time exceeds 10 seconds. Time it takes to fetch and/or read the input is not included in the measurement (The parsing of the input within the solution still is counted of course).

I compile it with `nim c -d:danger -d:release --opt:speed --passC:'flto' -r perf.nim`

```
Performance for 2015 by date and part
2015_01 part 1.....................0.004 ms (Ran 1000 times)
2015_01 part 2.....................0.002 ms (Ran 1000 times)
2015_20 part 1.....................196.485 ms (Ran 51 times)
2015_20 part 2.....................38.886 ms (Ran 258 times)
2015_21 part 1.....................0.406 ms (Ran 1000 times)
2015_21 part 2.....................0.406 ms (Ran 1000 times)
2015_22 part 1 (skipped)...........0.000 ms (Ran 0 times)
2015_22 part 2 (skipped)...........0.000 ms (Ran 0 times)
2015_23 part 1.....................0.038 ms (Ran 1000 times)
2015_23 part 2.....................0.044 ms (Ran 1000 times)
2015_24 part 1 (skipped)...........0.000 ms (Ran 0 times)
2015_24 part 2 (skipped)...........0.000 ms (Ran 0 times)


Performance for 2018 by date and part
2018_01 part 1.....................0.079 ms (Ran 1000 times)
2018_01 part 2.....................1.108 ms (Ran 1000 times)
2018_02 part 1.....................0.271 ms (Ran 1000 times)
2018_02 part 2.....................6.002 ms (Ran 1000 times)
2018_03 part 1.....................43.006 ms (Ran 233 times)
2018_03 part 2.....................1826.986 ms (Ran 6 times)
2018_04 part 1.....................3.479 ms (Ran 1000 times)
2018_04 part 2.....................3.479 ms (Ran 1000 times)
2018_05 part 1.....................5.454 ms (Ran 1000 times)
2018_05 part 2.....................141.197 ms (Ran 71 times)
2018_06 part 1.....................10.453 ms (Ran 957 times)
2018_06 part 2.....................7.874 ms (Ran 1000 times)
2018_07 part 1 (skipped)...........0.000 ms (Ran 0 times)
2018_07 part 2 (skipped)...........0.000 ms (Ran 0 times)


Performance for 2019 by date and part
2019_10 part 1.....................48.856 ms (Ran 205 times)
2019_10 part 2 (skipped)...........0.000 ms (Ran 0 times)


Performance for 2021 by date and part
2021_01 part 1.....................1.516 ms (Ran 1000 times)
2021_01 part 2.....................1.303 ms (Ran 1000 times)
2021_08 part 1.....................0.693 ms (Ran 1000 times)
2021_08 part 2.....................5557.882 ms (Ran 2 times)
2021_09 part 1.....................1.605 ms (Ran 1000 times)
2021_09 part 2.....................3.159 ms (Ran 1000 times)
2021_10 part 1.....................0.158 ms (Ran 1000 times)
2021_10 part 2.....................0.146 ms (Ran 1000 times)
2021_11 part 1.....................0.861 ms (Ran 1000 times)
2021_11 part 2.....................2.843 ms (Ran 1000 times)
2021_12 part 1.....................70.327 ms (Ran 143 times)
2021_12 part 2.....................1899.900 ms (Ran 6 times)
2021_13 part 1.....................0.384 ms (Ran 1000 times)
2021_13 part 2.....................0.569 ms (Ran 1000 times)
2021_14 part 1.....................65.795 ms (Ran 152 times)
2021_14 part 2.....................1.425 ms (Ran 1000 times)
2021_15 part 1.....................28.843 ms (Ran 347 times)
2021_15 part 2.....................2631.404 ms (Ran 4 times)
2021_16 part 1.....................3.461 ms (Ran 1000 times)
2021_16 part 2.....................3.377 ms (Ran 1000 times)
2021_17 part 1.....................0.338 ms (Ran 1000 times)
2021_17 part 2.....................40.450 ms (Ran 248 times)
2021_18 part 1.....................3.357 ms (Ran 1000 times)
2021_18 part 2.....................69.644 ms (Ran 144 times)
2021_20 part 1.....................25.890 ms (Ran 387 times)
2021_20 part 2.....................5699.559 ms (Ran 2 times)
2021_21 part 1.....................0.010 ms (Ran 1000 times)
2021_21 part 2.....................118.895 ms (Ran 85 times)
2021_22 part 1.....................17.487 ms (Ran 572 times)
2021_22 part 2.....................6.749 ms (Ran 1000 times)
2021_23 part 1.....................3642.859 ms (Ran 3 times)
2021_23 part 2.....................3383.569 ms (Ran 3 times)
2021_24 part 1.....................256.463 ms (Ran 39 times)
2021_24 part 2.....................254.046 ms (Ran 40 times)
2021_25 part 1.....................1818.640 ms (Ran 6 times)
2021_25 part 2.....................0.000 ms (Ran 1000 times)
```