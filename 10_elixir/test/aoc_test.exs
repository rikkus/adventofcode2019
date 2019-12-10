defmodule AocTest do
  use ExUnit.Case

  @input """
  #...##.####.#.......#.##..##.#.
  #.##.#..#..#...##..##.##.#.....
  #..#####.#......#..#....#.###.#
  ...#.#.#...#..#.....#..#..#.#..
  .#.....##..#...#..#.#...##.....
  ##.....#..........##..#......##
  .##..##.#.#....##..##.......#..
  #.##.##....###..#...##...##....
  ##.#.#............##..#...##..#
  ###..##.###.....#.##...####....
  ...##..#...##...##..#.#..#...#.
  ..#.#.##.#.#.#####.#....####.#.
  #......###.##....#...#...#...##
  .....#...#.#.#.#....#...#......
  #..#.#.#..#....#..#...#..#..##.
  #.....#..##.....#...###..#..#.#
  .....####.#..#...##..#..#..#..#
  ..#.....#.#........#.#.##..####
  .#.....##..#.##.....#...###....
  ###.###....#..#..#.....#####...
  #..##.##..##.#.#....#.#......#.
  .#....#.##..#.#.#.......##.....
  ##.##...#...#....###.#....#....
  .....#.######.#.#..#..#.#.....#
  .#..#.##.#....#.##..#.#...##..#
  .##.###..#..#..#.###...#####.#.
  #...#...........#.....#.......#
  #....##.#.#..##...#..####...#..
  #.####......#####.....#.##..#..
  .#...#....#...##..##.#.#......#
  #..###.....##.#.......#.##...##
  """

  test "1.1" do
    test_input = """
    .#..#
    .....
    #####
    ....#
    ...##
    """

    assert(Aoc.best_location(test_input) == {3, 4})
  end

  test "1.2" do
    test_input = """
    ......#.#.
    #..#.#....
    ..#######.
    .#.#.###..
    .#..#.....
    ..#....#.#
    #..#....#.
    .##.#..###
    ##...#..#.
    .#....####
    """

    assert(Aoc.best_location(test_input) == {5, 8})
  end

  test "1.3" do
    test_input = """
    #.#...#.#.
    .###....#.
    .#....#...
    ##.#.#.#.#
    ....#.#.#.
    .##..###.#
    ..#...##..
    ..##....##
    ......#...
    .####.###.
    """

    assert(Aoc.best_location(test_input) == {1, 2})
  end

  test "1.4" do
    test_input = """
    .#..#..###
    ####.###.#
    ....###.#.
    ..###.##.#
    ##.##.#.#.
    ....###..#
    ..#.#..#.#
    #..#.#.###
    .##...##.#
    .....#.#..
    """

    assert(Aoc.best_location(test_input) == {6, 3})
  end

  test "1.5" do
    test_input = """
    .#..##.###...#######
    ##.############..##.
    .#.######.########.#
    .###.#######.####.#.
    #####.##.#.##.###.##
    ..#####..#.#########
    ####################
    #.####....###.#.#.##
    ##.#################
    #####.##.###..####..
    ..######..##.#######
    ####.##.####...##..#
    .#####..#.######.###
    ##...#.##########...
    #.##########.#######
    .####.#.###.###.#.##
    ....##.##.###..#####
    .#.#.###########.###
    #.#.#.#####.####.###
    ###.##.####.##.#..##
    """

    assert(Aoc.best_location(test_input) == {11, 13})
  end

  test "part_one", do: assert(Aoc.best_location(@input) == :mu)
end
