defmodule Aoc do

  @spec direct_orbits(String.t(), String.t()) :: list(String.t())
  def direct_orbits(map, object) when is_binary(map),
    do: direct_orbits(parse(map), object)

  def direct_orbits(g, object),
    do: neighbours(g, object)

  @spec indirect_orbits(String.t(), String.t()) :: list(String.t())
  def indirect_orbits(map, object) when is_binary(map),
    do: indirect_orbits(parse(map), object)

  def indirect_orbits(g, object) do
    case orbits(g, object) do
      [_ | indirect] -> indirect
      [] -> []
    end
  end

  def orbits(g, object) do
    [_ | o] = orbits(g, object, []) |> Enum.reverse()
    o
  end

  defp orbits(_, nil, found), do: found
  defp orbits(g, object, found),
    do: orbits(g, parent(g, object), [object | found])

  def parent(g, v) do
    case neighbours(g, v) do
      [] -> nil
      [x] -> x
    end
  end

  def neighbours(g, v), do:
    Graph.out_edges(g, v) |> Enum.map(fn %Graph.Edge{v2: v2} -> v2 end)

  def orbits(map) do
    g = parse(map)
    g
    |> Graph.vertices()
    |> Enum.flat_map(fn object -> orbits(g, object) end)
  end

  @spec numbers ::
          ({:cont, any} | {:halt, any} | {:suspend, any}, any ->
             {:done, any} | {:halted, any} | {:suspended, any, (any -> any)})
  def numbers(),
    do: Stream.unfold(0, fn x -> {x + 1, x + 1} end)

  def part_two(map) do
    g = parse(map)
    you = orbits(g, "YOU") |> Enum.zip(numbers()) |> Map.new
    san = orbits(g, "SAN") |> Enum.zip(numbers()) |> Map.new
    common = MapSet.intersection(you |> Map.keys |> MapSet.new, san |> Map.keys |> MapSet.new)
    join = common |> Enum.min_by(fn key -> Map.get(you, key) + Map.get(san, key) end)
    Map.get(you, join) + Map.get(san, join) - 2
  end

  def parse(map) do
    map
    |> String.trim
    |> String.split("\n")
    |> Enum.map_reduce(
      Graph.new(type: :directed),
      fn (line, g) ->
        [to, from] = parse_line(line)
        { nil, g |> Graph.add_edge(Graph.Edge.new(from, to)) }
      end
    )
    |> elem(1)
  end

  def parse_line(line),
   do: String.split(line, ")")
end
