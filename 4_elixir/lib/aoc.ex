defmodule Aoc do
  @spec increasing?(list(non_neg_integer)) :: boolean
  defp increasing?([x, y | _]) when x > y, do: false
  defp increasing?([_, y | xs]), do: increasing?([y | xs])
  defp increasing?(_), do: true

  @spec digit_counts(Range.t()) :: nonempty_list(non_neg_integer)
  defp digit_counts(range) do
    range
    |> Enum.map(&Integer.digits/1)
    |> Enum.filter(&increasing?/1)
    |> Enum.map(fn digits ->
      digits
      |> Enum.group_by(& &1)
      |> Map.values()
      |> Enum.map(&length/1)
    end)
  end

  @spec part_one(Range.t()) :: non_neg_integer
  def part_one(range),
    do:
      range
      |> digit_counts
      |> Enum.count(fn v -> v |> Enum.any?(fn n -> n >= 2 end) end)

  @spec part_two(Range.t()) :: non_neg_integer
  def part_two(range),
    do:
      range
      |> digit_counts
      |> Enum.count(fn v -> v |> Enum.member?(2) end)
end
