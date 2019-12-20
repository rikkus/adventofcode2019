defmodule SampleRunner do
  import ExProf.Macro

  @input """
  <x=-15, y=1, z=4>
  <x=1, y=-10, z=-8>
  <x=-5, y=4, z=9>
  <x=4, y=6, z=-2>
  """

  @doc "analyze with profile macro"
  def do_analyze do
    profile do
      Aoc.part_two(@input)
    end
  end

  @doc "get analysis records and sum them up"
  def run do
    {records, _block_result} = do_analyze
    total_percent = Enum.reduce(records, 0.0, &(&1.percent + &2))
    IO.inspect "total = #{total_percent}"
  end
end
