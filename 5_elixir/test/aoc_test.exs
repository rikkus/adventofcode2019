defmodule AocTest do
  use ExUnit.Case

  def array(list), do: list |> :array.from_list() |> :array.fix()

  test "1.1",
    do: assert(Aoc.execute(array([3, 0, 4, 0, 99]), [42]) == [42])

  @input [
    3,
    225,
    1,
    225,
    6,
    6,
    1100,
    1,
    238,
    225,
    104,
    0,
    1102,
    9,
    19,
    225,
    1,
    136,
    139,
    224,
    101,
    -17,
    224,
    224,
    4,
    224,
    102,
    8,
    223,
    223,
    101,
    6,
    224,
    224,
    1,
    223,
    224,
    223,
    2,
    218,
    213,
    224,
    1001,
    224,
    -4560,
    224,
    4,
    224,
    102,
    8,
    223,
    223,
    1001,
    224,
    4,
    224,
    1,
    223,
    224,
    223,
    1102,
    25,
    63,
    224,
    101,
    -1575,
    224,
    224,
    4,
    224,
    102,
    8,
    223,
    223,
    1001,
    224,
    4,
    224,
    1,
    223,
    224,
    223,
    1102,
    55,
    31,
    225,
    1101,
    38,
    15,
    225,
    1001,
    13,
    88,
    224,
    1001,
    224,
    -97,
    224,
    4,
    224,
    102,
    8,
    223,
    223,
    101,
    5,
    224,
    224,
    1,
    224,
    223,
    223,
    1002,
    87,
    88,
    224,
    101,
    -3344,
    224,
    224,
    4,
    224,
    102,
    8,
    223,
    223,
    1001,
    224,
    7,
    224,
    1,
    224,
    223,
    223,
    1102,
    39,
    10,
    225,
    1102,
    7,
    70,
    225,
    1101,
    19,
    47,
    224,
    101,
    -66,
    224,
    224,
    4,
    224,
    1002,
    223,
    8,
    223,
    1001,
    224,
    6,
    224,
    1,
    224,
    223,
    223,
    1102,
    49,
    72,
    225,
    102,
    77,
    166,
    224,
    101,
    -5544,
    224,
    224,
    4,
    224,
    102,
    8,
    223,
    223,
    1001,
    224,
    4,
    224,
    1,
    223,
    224,
    223,
    101,
    32,
    83,
    224,
    101,
    -87,
    224,
    224,
    4,
    224,
    102,
    8,
    223,
    223,
    1001,
    224,
    3,
    224,
    1,
    224,
    223,
    223,
    1101,
    80,
    5,
    225,
    1101,
    47,
    57,
    225,
    4,
    223,
    99,
    0,
    0,
    0,
    677,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1105,
    0,
    99999,
    1105,
    227,
    247,
    1105,
    1,
    99999,
    1005,
    227,
    99999,
    1005,
    0,
    256,
    1105,
    1,
    99999,
    1106,
    227,
    99999,
    1106,
    0,
    265,
    1105,
    1,
    99999,
    1006,
    0,
    99999,
    1006,
    227,
    274,
    1105,
    1,
    99999,
    1105,
    1,
    280,
    1105,
    1,
    99999,
    1,
    225,
    225,
    225,
    1101,
    294,
    0,
    0,
    105,
    1,
    0,
    1105,
    1,
    99999,
    1106,
    0,
    300,
    1105,
    1,
    99999,
    1,
    225,
    225,
    225,
    1101,
    314,
    0,
    0,
    106,
    0,
    0,
    1105,
    1,
    99999,
    1008,
    677,
    226,
    224,
    1002,
    223,
    2,
    223,
    1005,
    224,
    329,
    1001,
    223,
    1,
    223,
    107,
    226,
    677,
    224,
    1002,
    223,
    2,
    223,
    1006,
    224,
    344,
    101,
    1,
    223,
    223,
    1007,
    677,
    677,
    224,
    1002,
    223,
    2,
    223,
    1006,
    224,
    359,
    1001,
    223,
    1,
    223,
    8,
    677,
    226,
    224,
    102,
    2,
    223,
    223,
    1005,
    224,
    374,
    101,
    1,
    223,
    223,
    108,
    226,
    677,
    224,
    102,
    2,
    223,
    223,
    1006,
    224,
    389,
    1001,
    223,
    1,
    223,
    1008,
    677,
    677,
    224,
    1002,
    223,
    2,
    223,
    1006,
    224,
    404,
    1001,
    223,
    1,
    223,
    1107,
    677,
    677,
    224,
    102,
    2,
    223,
    223,
    1005,
    224,
    419,
    1001,
    223,
    1,
    223,
    1008,
    226,
    226,
    224,
    102,
    2,
    223,
    223,
    1005,
    224,
    434,
    101,
    1,
    223,
    223,
    8,
    226,
    677,
    224,
    1002,
    223,
    2,
    223,
    1006,
    224,
    449,
    101,
    1,
    223,
    223,
    1007,
    677,
    226,
    224,
    102,
    2,
    223,
    223,
    1005,
    224,
    464,
    1001,
    223,
    1,
    223,
    107,
    677,
    677,
    224,
    1002,
    223,
    2,
    223,
    1005,
    224,
    479,
    1001,
    223,
    1,
    223,
    1107,
    226,
    677,
    224,
    1002,
    223,
    2,
    223,
    1005,
    224,
    494,
    1001,
    223,
    1,
    223,
    7,
    677,
    677,
    224,
    102,
    2,
    223,
    223,
    1006,
    224,
    509,
    101,
    1,
    223,
    223,
    1007,
    226,
    226,
    224,
    1002,
    223,
    2,
    223,
    1005,
    224,
    524,
    101,
    1,
    223,
    223,
    7,
    677,
    226,
    224,
    102,
    2,
    223,
    223,
    1005,
    224,
    539,
    101,
    1,
    223,
    223,
    8,
    226,
    226,
    224,
    1002,
    223,
    2,
    223,
    1006,
    224,
    554,
    101,
    1,
    223,
    223,
    7,
    226,
    677,
    224,
    102,
    2,
    223,
    223,
    1005,
    224,
    569,
    101,
    1,
    223,
    223,
    1108,
    677,
    226,
    224,
    1002,
    223,
    2,
    223,
    1005,
    224,
    584,
    101,
    1,
    223,
    223,
    108,
    677,
    677,
    224,
    1002,
    223,
    2,
    223,
    1006,
    224,
    599,
    101,
    1,
    223,
    223,
    107,
    226,
    226,
    224,
    1002,
    223,
    2,
    223,
    1006,
    224,
    614,
    101,
    1,
    223,
    223,
    1108,
    226,
    226,
    224,
    1002,
    223,
    2,
    223,
    1005,
    224,
    629,
    1001,
    223,
    1,
    223,
    1107,
    677,
    226,
    224,
    1002,
    223,
    2,
    223,
    1005,
    224,
    644,
    101,
    1,
    223,
    223,
    108,
    226,
    226,
    224,
    1002,
    223,
    2,
    223,
    1005,
    224,
    659,
    101,
    1,
    223,
    223,
    1108,
    226,
    677,
    224,
    1002,
    223,
    2,
    223,
    1005,
    224,
    674,
    1001,
    223,
    1,
    223,
    4,
    223,
    99,
    226
  ]

  test "part_one", do: assert(Aoc.execute(array(@input), [1]) |> hd() == 13787043)
  test "part_two", do: assert(Aoc.execute(array(@input), [5]) |> hd() == 3892695)
end
