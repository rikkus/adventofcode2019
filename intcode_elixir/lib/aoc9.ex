defmodule Aoc9 do
  def part_one(mem, input \\ []) do
    Computer.new("bob", :array.from_list(mem, 0), input, after_output: :continue)
    |> Computer.execute()
    |> Computer.output()
  end
end
