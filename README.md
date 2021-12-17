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

Performance for 2015 by speed
2015_22 part 1 (skipped)...........0.000 ms (Ran 0 times)
2015_22 part 2 (skipped)...........0.000 ms (Ran 0 times)
2015_01 part 1.....................0.000 ms (Ran 1000 times)
2015_01 part 2.....................0.000 ms (Ran 1000 times)
2015_23 part 2.....................0.037 ms (Ran 1000 times)
2015_23 part 1.....................0.059 ms (Ran 1000 times)
2015_21 part 2.....................0.389 ms (Ran 1000 times)
2015_21 part 1.....................0.412 ms (Ran 1000 times)
2015_20 part 1.....................245.135 ms (Ran 41 times)
2015_20 part 2.....................250.048 ms (Ran 40 times)


Performance for 2021 by date and part
2021_01 part 1.....................1.131 ms (Ran 1000 times)
2021_01 part 2.....................1.187 ms (Ran 1000 times)
2021_08 part 1.....................0.649 ms (Ran 1000 times)
2021_08 part 2.....................0.642 ms (Ran 1000 times)
2021_09 part 1.....................1.543 ms (Ran 1000 times)
2021_09 part 2.....................1.550 ms (Ran 1000 times)
2021_10 part 1.....................0.154 ms (Ran 1000 times)
2021_10 part 2.....................0.153 ms (Ran 1000 times)
2021_11 part 1.....................0.891 ms (Ran 1000 times)
2021_11 part 2.....................0.893 ms (Ran 1000 times)
2021_12 part 1.....................61.746 ms (Ran 162 times)
2021_12 part 2.....................63.030 ms (Ran 159 times)
2021_13 part 1.....................0.353 ms (Ran 1000 times)
2021_13 part 2.....................0.350 ms (Ran 1000 times)
2021_14 part 1.....................80.805 ms (Ran 124 times)
2021_14 part 2.....................76.578 ms (Ran 132 times)
2021_15 part 1.....................35.917 ms (Ran 279 times)
2021_15 part 2.....................34.498 ms (Ran 290 times)
2021_16 part 1.....................3.186 ms (Ran 1000 times)
2021_16 part 2.....................3.247 ms (Ran 1000 times)
2021_17 part 1.....................0.245 ms (Ran 1000 times)
2021_17 part 2.....................0.244 ms (Ran 1000 times)

Performance for 2021 by speed
2021_10 part 2.....................0.153 ms (Ran 1000 times)
2021_10 part 1.....................0.154 ms (Ran 1000 times)
2021_17 part 2.....................0.244 ms (Ran 1000 times)
2021_17 part 1.....................0.245 ms (Ran 1000 times)
2021_13 part 2.....................0.350 ms (Ran 1000 times)
2021_13 part 1.....................0.353 ms (Ran 1000 times)
2021_08 part 2.....................0.642 ms (Ran 1000 times)
2021_08 part 1.....................0.649 ms (Ran 1000 times)
2021_11 part 1.....................0.891 ms (Ran 1000 times)
2021_11 part 2.....................0.893 ms (Ran 1000 times)
2021_01 part 1.....................1.131 ms (Ran 1000 times)
2021_01 part 2.....................1.187 ms (Ran 1000 times)
2021_09 part 1.....................1.543 ms (Ran 1000 times)
2021_09 part 2.....................1.550 ms (Ran 1000 times)
2021_16 part 1.....................3.186 ms (Ran 1000 times)
2021_16 part 2.....................3.247 ms (Ran 1000 times)
2021_15 part 2.....................34.498 ms (Ran 290 times)
2021_15 part 1.....................35.917 ms (Ran 279 times)
2021_12 part 1.....................61.746 ms (Ran 162 times)
2021_12 part 2.....................63.030 ms (Ran 159 times)
2021_14 part 2.....................76.578 ms (Ran 132 times)
2021_14 part 1.....................80.805 ms (Ran 124 times)
```