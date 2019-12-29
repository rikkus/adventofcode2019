defmodule AocTest do
  use ExUnit.Case

  @input File.read!("test/input")

  test "123456789012",
    do: assert(Aoc.part_one("123456789012", 3, 2) == 1)

  test "part_one",
    do: assert(Aoc.part_one(@input, 25, 6) == 2806)

  test "part_two",
    do: Aoc.part_two(@input, 25, 6)
end
