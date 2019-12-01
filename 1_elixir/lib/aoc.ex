defmodule Aoc do
  def fuel_required(mass),
    do: (div(mass, 3) - 2) |> max(0)

  def total_fuel_required(mass),
    do: total_fuel_required(mass, 0)

  def total_fuel_required(0, total),
    do: total

  def total_fuel_required(mass, total) do
    f = fuel_required(mass)
    total_fuel_required(f, total + f)
  end

  @spec part_one(binary) :: number
  def part_one(input),
    do:
      input
      |> parse
      |> Enum.map(&fuel_required/1)
      |> Enum.sum()

  def part_two(input),
    do:
      input
      |> parse
      |> Enum.map(&total_fuel_required/1)
      |> Enum.sum()

  def parse(input),
    do:
      input
      |> String.trim()
      |> String.split()
      |> Enum.map(&String.to_integer/1)
end
