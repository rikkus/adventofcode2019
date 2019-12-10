    defmodule Aoc do
      def part_one(map) do
        graph = parse(map)
        graph |> Map.keys() |> Enum.flat_map(fn object -> orbits(graph, object) end)
      end

      def part_two(map) do
        graph = parse(map)
        you = orbits(graph, "YOU") |> Enum.zip(numbers()) |> Map.new()
        san = orbits(graph, "SAN") |> Enum.zip(numbers()) |> Map.new()

        MapSet.intersection(you |> Map.keys() |> MapSet.new(), san |> Map.keys() |> MapSet.new())
        |> Enum.map(fn key -> Map.get(you, key) + Map.get(san, key) end)
        |> Enum.min
      end

      defp orbits(g, object), do: orbits(g, object, []) |> Enum.reverse() |> Enum.drop(1)
      defp orbits(_, nil, found), do: found
      defp orbits(g, object, found), do: orbits(g, Map.get(g, object), [object | found])

      defp numbers(), do: Stream.iterate(0, &(&1 + 1))

      defp parse(map) do
        map
        |> String.split("\n", trim: true)
        |> Enum.reduce(%{}, fn line, g ->
          [to, from] = String.split(line, ")")
          Map.put(g, from, to)
        end)
      end
    end
