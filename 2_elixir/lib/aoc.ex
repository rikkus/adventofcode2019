defmodule Aoc do
  def part_one(input),
    do: run(input, 12, 2)

  def part_two(input),
    do: part_two(input, 99, 99)

  def part_two(input, noun, -1),
    do: part_two(input, noun - 1, 99)

  def part_two(input, noun, verb) do
    case run(input, noun, verb) do
      19_690_720 -> 100 * noun + verb
      _ -> part_two(input, noun, verb - 1)
    end
  end

  def to_indexed_map(input),
    do:
      0..length(input)
      |> Enum.zip(input)
      |> Map.new()

  def run(input, noun, verb),
    do:
      %{(input |> to_indexed_map()) | 1 => noun, 2 => verb}
      |> run(0)
      |> Map.get(0)

  def run(input),
    do:
      input
      |> to_indexed_map()
      |> run(0)
      |> Map.values()

  def run(input, ip) do
    case input[ip] do
      1 -> run(input |> operator(ip, &+/2), ip + 4)
      2 -> run(input |> operator(ip, &*/2), ip + 4)
      99 -> input
    end
  end

  def operator(input, ip, op),
    do:
      input
      |> Map.merge(%{
        input[ip + 3] => op.(input[input[ip + 1]], input[input[ip + 2]])
      })
end
