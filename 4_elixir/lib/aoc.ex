defmodule Aoc do

  def ok?(n) when is_integer(n),
    do: ok?(Integer.digits(n), [], [])

  def ok?([x | xs], [], []), do: ok?(xs, [x], [x])

  def ok?([x | _], [y | _], _)
    when x < y,
    do: false

  def ok?([x | xs], ys, [z, _])
    when x == z,
    do: ok?(xs, [x | ys], [])

  def ok?([x | xs], ys, [z, _])
    when x != z,
    do: ok?(xs, [x | ys], [z, z])

  def ok?([x | xs], [y1, y2 | ys], [z | _])
    when x == y1
    and y1 == y2
    and x == z,
    do: ok?(xs, [x, y1, y2 | ys], [])

  def ok?([x | xs], [y1, y2 | ys], zs)
    when x == y1
    and y1 == y2,
    do: ok?(xs, [x, y1, y2 | ys], zs)

  def ok?([x | xs], [y | ys], [z])
    when x == y
    and x == z,
    do: ok?(xs, [x, y | ys], [z, z])

  def ok?([x | xs], [y | ys], _)
    when x == y,
    do: ok?(xs, [x, y | ys], [x, y])

  def ok?([x | xs], [y | ys], zs),
    do: ok?(xs, [x, y | ys], zs)

  def ok?([], _, [_, _]),
    do: true

  def ok?([], _, _),
    do: false

  def count_ok(input),
    do: input |> Enum.count(fn n -> n |> ok? end)
end
