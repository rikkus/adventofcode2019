defmodule Maths do
  @spec factor(pos_integer()) :: list(pos_integer())
  def factor(n),
    do: factor(n, 1, []) |> Enum.sort()

  defp factor(n, i, factors) when n < i * i,
    do: factors

  defp factor(n, i, factors) when n == i * i,
    do: [i | factors]

  defp factor(n, i, factors) when rem(n, i) == 0,
    do: factor(n, i + 1, [i, div(n, i) | factors])

  defp factor(n, i, factors),
    do: factor(n, i + 1, factors)
end
