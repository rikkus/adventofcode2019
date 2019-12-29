defmodule Aoc do
  def part_one(mem) do
    mem = :array.from_list(mem)

    permutations([0, 1, 2, 3, 4])
    |> Enum.map(fn combo -> execute_combo(mem, combo, 0) end)
    |> Enum.max()
  end

  def execute_combo(mem, [p1, p2, p3, p4, p5], input_signal) do
    o1 = Computer.new("1", mem, [p1, input_signal]) |> Computer.execute() |> Computer.output()
    o2 = Computer.new("2", mem, [p2, o1]) |> Computer.execute() |> Computer.output()
    o3 = Computer.new("3", mem, [p3, o2]) |> Computer.execute() |> Computer.output()
    o4 = Computer.new("4", mem, [p4, o3]) |> Computer.execute() |> Computer.output()
    Computer.new("5", mem, [p5, o4]) |> Computer.execute() |> Computer.output()
  end

  def part_two(mem, debug? \\ false) do
    permutations([5, 6, 7, 8, 9])
    |> Enum.map(fn permutation -> do_part_two(:array.from_list(mem), permutation, debug?) end)
    |> Enum.max()
  end

  def do_part_two(mem, [p1, p2, p3, p4, p5], debug?) do
    #IO.inspect([p1, p2, p3, p4, p5])
    c1 = Computer.new("1", mem, [p1, 0], debug?)
    c2 = Computer.new("2", mem, [p2], debug?)
    c3 = Computer.new("3", mem, [p3], debug?)
    c4 = Computer.new("4", mem, [p4], debug?)
    c5 = Computer.new("5", mem, [p5], debug?)

    c = [c1, c2, c3, c4, c5]
    do_part_two(c, nil)
  end

  def do_part_two([c1, c2, c3, c4, c5], output) do
    IO.puts "Asking computer #{c1.name} (which has input #{Enum.at(c1.inputs, 0)}) to execute"
    c1 = Computer.execute(c1)
    IO.puts "Output from computer #{c1.name}: #{inspect(c1.outputs, charlists: :as_lists)}"
    case c1 do
      %Computer{running: true, outputs: [o]} ->
        do_part_two([%Computer{c2 | inputs: c2.inputs ++ [o]}, c3, c4, c5, %Computer{c1 | outputs: []}], o)

      %Computer{running: false} -> output
    end
  end

  def permutations(l),
    do: do_permutations(l, [], [])

  defp do_permutations([], x, acc),
    do: [x | acc]

  defp do_permutations(list, x, acc) do
    list
    |> Stream.unfold(fn [x | xs] -> {{x, xs}, xs ++ [x]} end)
    |> Enum.take(length(list))
    |> Enum.reduce(acc, fn {h, t}, acc -> do_permutations(t, [h | x], acc) end)
  end
end
