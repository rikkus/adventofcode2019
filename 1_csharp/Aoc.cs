using System;
using System.Linq;
using System.Collections.Generic;
using System.Collections.Immutable;

namespace aoc
{
  class Aoc
  {
    public static int FuelRequired(int mass) => (mass / 3) - 2;
    public static int TotalFuelRequired(int mass, int total)
    {
      int f = FuelRequired(mass);
      if (f <= 0)
        return total;
      else
        return TotalFuelRequired(f, total + f);
    }

    public static int PartOne(string input) =>
      Parse(input).Select(i => FuelRequired(i)).Sum();

    public static int PartTwo(string input) => 
      Parse(input).Select(i => TotalFuelRequired(i, 0)).Sum();

    private static IEnumerable<int> Parse(string input) =>
      input.Trim().Split("\n").Select(s => int.Parse(s));
  }
}