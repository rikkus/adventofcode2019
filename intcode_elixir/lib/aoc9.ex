defmodule Aoc9 do
  @spec memory(list(integer)) :: Computer.memory()
  def memory(list), do: :array.from_list(list, 0)

  @spec part_one(list(integer()), list(integer())) :: list(integer)
  def part_one(mem, input \\ []) do
    Computer.new("bob", memory(mem), input)
    |> Computer.execute(after_output: :continue)
    |> Computer.output()
  end
end
