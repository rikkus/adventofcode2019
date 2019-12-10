defmodule Aoc do
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} -> parse_row(row, y) end)
    |> Map.new
  end

  def parse_row(row, y) do
    row
    |> String.codepoints
    |> Enum.with_index()
    |> Enum.map(fn {c, x} -> {{x, y}, c} end)
  end

  def asteroids(map) do
    map
    |> Enum.filter(fn {{_, _}, c} -> c == "#" end)
    |> MapSet.new(fn {{x, y}, _} -> {x, y} end)
  end

  def best_location(input) do
    map = parse(input)
    asteroids = asteroids(map)
    asteroids
    |> Enum.max_by(fn asteroid -> visible_count(asteroid, MapSet.delete(asteroids, asteroid)) end)
  end

  def visible_count(asteroid, asteroids) do
    asteroids
    |> Enum.count(fn a -> asteroid |> path_clear_to?(a, MapSet.delete(asteroids, a)) end)
  end

  def path_clear_to?(a, b, others) do

    false
  end
end
