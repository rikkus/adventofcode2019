defmodule Aoc do
  @type intvec2d :: {integer, integer}

  def best_location(input),
   do: input
    |> parse()
    |> find_asteroids()
    |> best()

  def best(asteroids),
    do:
      asteroids
      |> Enum.map(fn asteroid ->
        {
          asteroid,
          visible_count(asteroid, MapSet.delete(asteroids, asteroid))
        }
      end)
      |> Enum.max_by(fn {_asteroid, count} -> count end)

  def zap(input) do
    asteroids = input |> parse() |> find_asteroids()
    {best, _} = asteroids |> best()
    others = asteroids |> MapSet.delete(best)
    IO.inspect(best, label: "best")
    IO.inspect(others, label: "others")

    grouped =
      others
    |> Enum.map(fn other -> {other, angle_between(best, other), distance_between(best, other)} end)
    |> Enum.group_by(fn {_, angle, _} -> angle end, fn {other, _angle, distance} ->
      {other, distance}
    end)
    |> Enum.map(fn {k, v} -> {k, v |> Enum.sort_by(fn {{_, _}, d} -> d end)} end)

    {x, y} = flatten(grouped, 1)

    x * 100 + y
  end

  def flatten(foo, 200),
    do: foo

  def flatten([{_, [{{x, y}, _}]}], _n),
    do: {x, y}

  def flatten([{_, [_]} | rest], n),
    do: flatten(rest, n + 1)

  def flatten([{angle, [_ | asteroids]} | rest], n),
    do: flatten([{angle, asteroids} | rest], n + 1)

  def distance_between({ax, ay}, {bx, by}),
    do: :math.sqrt(:math.pow(ax - bx, 2) + :math.pow(ay - by, 2))

  defp parse(input),
    do:
      input
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, y} -> parse_row(row, y) end)
      |> Map.new()

  defp parse_row(row, y),
    do:
      row
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {c, x} -> {{x, y}, c} end)

  defp find_asteroids(map),
    do:
      map
      |> Enum.filter(fn {_point, c} -> c == "#" end)
      |> MapSet.new(fn {point, _} -> point end)

  defp visible_count(asteroid, asteroids) do
    asteroids
    |> Enum.count(fn a ->
      asteroid |> path_clear_between?(a, MapSet.delete(asteroids, a), 0.001)
    end)
  end

  @spec path_clear_between?(intvec2d, intvec2d, MapSet.t(intvec2d), number) :: boolean
  defp path_clear_between?(a, b, others, epsilon),
    do: !path_obstructed?(a, b, others, epsilon)

  defp path_obstructed?(a, b, others, epsilon),
    do:
      others
      |> Enum.any?(fn other -> point_on_line_and_in_line_segment(a, b, other, epsilon) end)

  def dot({ax, ay}, {bx, by}),
    do: ax * bx + ay * by

  defp cross({ax, ay}, {bx, by}),
    do: ax * by - ay * bx

  def radians_to_degrees(radians),
    do: radians * 180 / :math.pi()

  def angle_between({ax, ay}, {bx, by}),
    do: 180 - (:math.atan2(bx - ax, ay - by) |> radians_to_degrees())

  defp perp_dot_product({ax, ay}, {bx, by}, {cx, cy}),
    do: (ax - cx) * (by - cy) - (ay - cy) * (bx - cx)

  defp point_on_line?(a, b, p, epsilon),
    do: abs(perp_dot_product(a, b, p)) < epsilon

  defp point_in_x_range({ax, _ay}, {bx, _by}, {px, _py}),
    do: (ax <= px && px <= bx) || (bx <= px && px <= ax)

  defp point_in_y_range({_ax, ay}, {_bx, by}, {_px, py}),
    do: (ay <= py && py <= by) || (by <= py && py <= ay)

  defp point_on_line_and_in_line_segment(a, b, p, epsilon) do
    point_in_x_range(a, b, p) &&
      point_in_y_range(a, b, p) &&
      point_on_line?(a, b, p, epsilon)
  end
end
