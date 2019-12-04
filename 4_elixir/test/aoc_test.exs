defmodule AocTest do
  use ExUnit.Case
  @range 240_920..789_857
  test "part_one", do: assert(Aoc.part_one(@range) == 1154)
  test "part_two", do: assert(Aoc.part_two(@range) == 750)
end
