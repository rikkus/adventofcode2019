defmodule Aoc13 do
  def part_one(mem) do
    Computer.new("intanoid", :array.from_list(mem), [])
    |> Computer.execute()
    |> Computer.output()
    |> Stream.chunk_every(3)
    |> Enum.count(fn [_x, _y, id] -> id == 2 end)
  end

  def part_two([_ | mem]) do
    Computer.new("intanoid", :array.from_list([2 | mem], 0), [])
    |> play(%{})
  end

  def play(computer, world) do
    case computer |> exec() do
      %Computer{outputs: [-1, 0, score]} -> score
      %Computer{outputs: [x, y, id]} = computer -> play(%Computer{computer | outputs: []}, world |> update({x, y, id}))
      %Computer{state: :awaiting_input} = computer -> play(%Computer{computer | inputs: [direction(world)]}, world)
    end
  end

  def direction(world) do

  end

  def exec(computer) do
    computer
    |> Computer.execute(after_output: :idle)
    |> Computer.execute(after_output: :idle)
    |> Computer.execute(after_output: :idle)
  end

  def update(world, {x, y, id}) do
    Map.put(world, {x, y}, id)
  end
end
