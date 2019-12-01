defmodule AocTest do
  use ExUnit.Case

  @input """
    95249
    126697
    77237
    80994
    91186
    53823
    115101
    130919
    88127
    141736
    53882
    67432
    94292
    73223
    139947
    66450
    55710
    128647
    73874
    57163
    139502
    140285
    119987
    125308
    77561
    74573
    85364
    92991
    102935
    71259
    99622
    118876
    124482
    148442
    77664
    90453
    111933
    110449
    74172
    148641
    58574
    135365
    84703
    81077
    65290
    136749
    127256
    94872
    143534
    81702
    59493
    72365
    69497
    149082
    79552
    78509
    73759
    147439
    97535
    118952
    114301
    104401
    95080
    100907
    132914
    136096
    52451
    70544
    120717
    107010
    76840
    51324
    135258
    73985
    118067
    86602
    95127
    51182
    84838
    60430
    86347
    140487
    147777
    85143
    114215
    100410
    126504
    69630
    123656
    108886
    144192
    123620
    147217
    146090
    101966
    80577
    62193
    143331
    79947
    93518
  """

  # For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2.
  test "1.1", do: assert(Aoc.fuel_required(12) == 2)

  # For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2.
  test "1.2", do: assert(Aoc.fuel_required(14) == 2)
  test "1.3", do: assert(Aoc.fuel_required(1969) == 654)
  test "1.4", do: assert(Aoc.fuel_required(100_756) == 33583)
  test "part_one", do: assert(Aoc.part_one(@input) == 3_331_523)

  test "2.1", do: assert(Aoc.total_fuel_required(14) == 2)
  test "2.2", do: assert(Aoc.total_fuel_required(1969) == 966)
  test "2.3", do: assert(Aoc.total_fuel_required(100_756) == 50346)
  test "part_two", do: assert(Aoc.part_two(@input) == 4_994_396)
end
