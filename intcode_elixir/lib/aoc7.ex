defmodule Aoc7 do
  def part_one(mem) do
    mem = :array.from_list(mem)

    permutations([0, 1, 2, 3, 4])
    |> Enum.map(fn combo -> execute_combo(mem, combo, 0) end)
    |> Enum.max()
  end

  def execute_combo(mem, [p1, p2, p3, p4, p5], input_signal) do
    input_signal
    |> run("1", mem, p1)
    |> run("2", mem, p2)
    |> run("3", mem, p3)
    |> run("4", mem, p4)
    |> run("5", mem, p5)
  end

  @spec run(integer, binary, :array.array(integer), integer) :: integer
  def run(input, name, mem, phase),
    do:
      Computer.new(name, mem, [phase, input])
      |> Computer.execute()
      |> Computer.last_output()

  def part_two(mem) do
    permutations([5, 6, 7, 8, 9])
    |> Enum.map(fn permutation -> do_part_two(:array.from_list(mem), permutation) end)
    |> Enum.max()
  end

  def do_part_two(mem, [p1, p2, p3, p4, p5]) do
    # IO.inspect([p1, p2, p3, p4, p5])
    c1 = Computer.new("1", mem, [p1, 0])
    c2 = Computer.new("2", mem, [p2])
    c3 = Computer.new("3", mem, [p3])
    c4 = Computer.new("4", mem, [p4])
    c5 = Computer.new("5", mem, [p5])

    do_part_two(c1, c2, c3, c4, c5)
  end

  def do_part_two(c1, c2, c3, c4, c5, max \\ 0) do
    # IO.puts(
    #  "Asking computer #{c1.name} (which has input #{inspect(c1.inputs, charlists: :as_lists)}) to execute"
    # )

    %Computer{state: state, outputs: [last_output | _]} =
      result = Computer.execute(c1, after_output: :idle)

    # IO.puts("Output from computer #{c1.name}: #{inspect(c1.outputs, charlists: :as_lists)}")
    max = max(last_output, max)

    case state do
      :halted -> max
      :idle -> do_part_two(c2 |> Computer.input([last_output]), c3, c4, c5, result, max)
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
