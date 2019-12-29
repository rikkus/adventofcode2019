defmodule Aoc2 do
  def part_one(input),
    do: run(input, 12, 2) |> Enum.at(0)

  def part_two(input),
    do: part_two(input, 99, 99)

  def part_two(input, noun, -1),
    do: part_two(input, noun - 1, 99)

  def part_two(input, noun, verb) do
    case run(input, noun, verb) |> Enum.at(0) do
      19_690_720 -> 100 * noun + verb
      _ -> part_two(input, noun, verb - 1)
    end
  end

  def run(input, noun, verb) do
    input = input |> :array.from_list()
    input = :array.set(1, noun, input)
    input = :array.set(2, verb, input)

    input |> run()
  end

  def run(input) when is_list(input),
    do: run(:array.from_list(input))

  def run(input) do
    %Computer{mem: mem} =
      Computer.new("", input, [])
      |> Computer.execute()

    mem |> :array.to_list()
  end

  def operator(input, ip, op),
    do:
      input
      |> Map.merge(%{
        input[ip + 3] => op.(input[input[ip + 1]], input[input[ip + 2]])
      })
end
