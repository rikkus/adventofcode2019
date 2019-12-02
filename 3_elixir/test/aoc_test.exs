defmodule AocTest do
  use ExUnit.Case

  test "1.1", do: assert(Aoc.run() == 42)
  test "1.2", do: assert(Aoc.run() == 42)
  test "1.3", do: assert(Aoc.run() == 42)
  test "1.4", do: assert(Aoc.run() == 42)

  test "2.1", do: assert(Aoc.run() == 42)
  test "2.2", do: assert(Aoc.run() == 42)
  test "2.3", do: assert(Aoc.run() == 42)
  test "2.4", do: assert(Aoc.run() == 42)

  @input ""

  test "part_one", do: assert(Aoc.part_one(@input) == 42)
  test "part_two", do: assert(Aoc.part_two(@input) == 42)
end
