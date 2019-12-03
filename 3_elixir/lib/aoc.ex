defmodule Aoc do

  def integers(),
    do: Stream.unfold(1, fn x -> {x, x + 1} end)

  def closest_intersection(input) do
    [line1, line2] = String.split(input, "\n") |> Enum.map(&parse_line/1)
    intersections = MapSet.intersection(MapSet.new(line1), MapSet.new(line2))
    Enum.min_by(intersections, fn {x, y} -> manhattan_distance({0, 0}, {x, y}) end)
    |> manhattan_distance({0, 0})
  end

  def manhattan_distance({x1, y1}, {x2, y2}),
    do: abs(x1 - x2) + abs(y1 - y2)

  def parse_line(input),
    do: execute_commands(input |> String.split(",") |> Enum.map(&parse_command/1), {0, 0}, [])

  def parse_command(<<direction :: utf8, count :: binary>>),
    do: {direction, String.to_integer(count)}

  def execute_commands([], _position, positions),
    do: positions

  def execute_commands([{_direction, 0} | commands], {x, y}, positions),
    do: execute_commands(commands, {x, y}, positions)

  def execute_commands([{direction, count} | commands], {x, y}, positions) do
    new_position = move({x, y}, direction)
    execute_commands([{direction, count - 1} | commands], new_position, [new_position | positions])
  end

  def move({x, y}, ?R), do: {x + 1, y}
  def move({x, y}, ?L), do: {x - 1, y}
  def move({x, y}, ?U), do: {x, y - 1}
  def move({x, y}, ?D), do: {x, y + 1}

  def first_offsets_for_each_visited_position(line) do
    {_, offsets} =
      line
      |> Enum.reverse()
      |> Enum.zip(integers())
      |> Enum.map_reduce(%{}, fn ({pos, n}, acc) -> {n, Map.put_new(acc, pos, n)} end)

    offsets
  end

  def fewest_steps(input) do
    [line1, line2] = String.split(input, "\n") |> Enum.map(&parse_line/1)

    intersections = MapSet.intersection(MapSet.new(line1), MapSet.new(line2))

    line1_offsets = first_offsets_for_each_visited_position(line1)
    line2_offsets = first_offsets_for_each_visited_position(line2)

    Enum.map(
      intersections,
      fn {x, y} -> line1_offsets[{x, y}] + line2_offsets[{x, y}] end)
      |> Enum.min()
  end

  def part_one(input),
    do: closest_intersection(input)

  def part_two(input),
    do: fewest_steps(input)
end
