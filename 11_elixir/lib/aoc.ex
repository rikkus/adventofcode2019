defmodule Vec do
  defstruct x: 0, y: 0, z: 0
end

defmodule Moon do
  defstruct pos: %Vec{}, vel: %Vec{}
end

defmodule Aoc do
  defp parse(input),
    do:
      String.split(input, "\n", trim: true)
      |> Enum.map(&parse_line/1)

  defp parse_line(input) do
    [x, y, z] =
      Regex.scan(~r/-?\d+/, input)
      |> Enum.map(fn [x] -> String.to_integer(x) end)

    %Moon{pos: %Vec{x: x, y: y, z: z}}
  end

  defp show(moons),
    do: moons |> Enum.map(&show_moon/1)

  def show_moon(%Moon{pos: %Vec{x: px, y: py, z: pz}, vel: %Vec{x: vx, y: vy, z: vz}}) do
    [px, py, pz, vx, vy, vz] =
      [px, py, pz, vx, vy, vz]
      |> Enum.map(fn s -> String.pad_leading(Integer.to_string(s), 3, " ") end)

    IO.puts "pos=<x=#{px}, y=#{py}, z=#{pz}>, vel=<x=#{vx}, y=#{vy}, z=#{vz}>"
  end

  def part_one(input, reps) do
    moons = parse(input)

    refs = Stream.iterate(1, &(&1 + 1))
    moon_map = refs |> Enum.zip(moons) |> Map.new()

    combos = combinations(Map.keys(moon_map), 2)
    moon_map = step(moon_map, combos, reps)

    moon_map
    |> Map.values
    |> Enum.map(fn moon -> total_energy(moon) end)
    |> Enum.sum
  end

  def part_two(input) do
    moons = parse(input)

    refs = Stream.iterate(1, &(&1 + 1))
    moon_map = refs |> Enum.zip(moons) |> Map.new()

    set = MapSet.new()
    MapSet.put(set, moon_map)
    combos = combinations(Map.keys(moon_map), 2)
    find_match(set, moon_map, combos, 0)
  end

  defp find_match(set, moon_map, combos, n) do
    next = step(moon_map, combos)
    if n != 0 && rem(n, 1_000_000) == 0 do
     IO.puts n
    end
      if MapSet.member?(set, next) do
        n
      else
        find_match(MapSet.put(set, next), next, combos, n + 1)
      end
  end

  defp combinations(_, 0), do: [[]]
  defp combinations([], _), do: []

  defp combinations([h | t], m) do
    for(l <- combinations(t, m - 1), do: [h | l]) ++ combinations(t, m)
  end

  defp step(moon_map, _combos, 0), do: moon_map
  defp step(moon_map, combos, n), do: step(step(moon_map, combos), combos, n - 1)

  defp step(moons, combos) do
    combos
    |> Enum.reduce(
      moons,
      fn [m1ref, m2ref], map ->
        {m1, m2} = {map[m1ref], map[m2ref]}
        map |> Map.put(m1ref, apply_gravity(m1, m2.pos)) |> Map.put(m2ref, apply_gravity(m2, m1.pos))
      end
    )
    |> Enum.map(fn {key, moon} -> {key, apply_velocity(moon)} end)
    |> Map.new
  end

  defp total_energy(moon),
    do: potential_energy(moon) * kinetic_energy(moon)

  defp potential_energy(%Moon{pos: %Vec{x: px, y: py, z: pz}}),
    do: abs(px) + abs(py) + abs(pz)

  defp kinetic_energy(%Moon{vel: %Vec{x: vx, y: vy, z: vz}}),
    do: abs(vx) + abs(vy) + abs(vz)

  defp apply_gravity(%Moon{:pos => pos1, :vel => v1} = m1, pos2),
   do: %Moon{m1 | vel: add(v1, dv(pos1, pos2))}

  defp apply_velocity(%Moon{:pos => p, :vel => v} = m),
   do: %Moon{m | pos: add(p, v)}

  defp add(%Vec{x: x, y: y, z: z}, %Vec{x: dx, y: dy, z: dz}),
    do: %Vec{x: x + dx, y: y + dy, z: z + dz}

  defp dv(%Vec{x: x1, y: y1, z: z1}, %Vec{x: x2, y: y2, z: z2}),
    do: %Vec{x: dvi(x1, x2), y: dvi(y1, y2), z: dvi(z1, z2)}

  defp dvi(pos1, pos2) do
    cond do
      pos1 < pos2 -> 1
      pos1 > pos2 -> -1
      true -> 0
    end
  end
end
