defmodule AocTest do
  use ExUnit.Case
  test "1.1", do: assert(!Aoc.ok?(111111))
  test "1.2", do: assert(!Aoc.ok?(223450))
  test "1.3", do: assert(!Aoc.ok?(123789))
  test "2.1", do: assert(Aoc.ok?(112233))
  test "2.2", do: assert(!Aoc.ok?(123444))
  test "2.3", do: assert(Aoc.ok?(111122))
  test "part_two", do: assert(Aoc.count_ok(240920..789857) == :mu)
end
