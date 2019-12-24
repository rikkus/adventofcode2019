defmodule AocTest do
  use ExUnit.Case

  @test_input """
  <x=-1, y=0, z=2>
  <x=2, y=-10, z=-7>
  <x=4, y=-8, z=8>
  <x=3, y=5, z=-1>
  """

  @input """
  <x=-15, y=1, z=4>
  <x=1, y=-10, z=-8>
  <x=-5, y=4, z=9>
  <x=4, y=6, z=-2>
  """

  test "1.1", do: assert(Aoc.part_one(@test_input, 10) == 179)
  test "part_one", do: assert(Aoc.part_one(@input, 1000) == 8625)

  test "2.1", do: assert(Aoc.part_two(@test_input) == 2772)

  @tag timeout: :infinity
  test "part_two", do: assert(Aoc.part_two(@input) == 8625)
end
