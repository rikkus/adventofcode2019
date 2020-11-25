defmodule Aoc11 do
  @north {0, -1}
  @south {0, 1}
  @east {1, 0}
  @west {-1, 0}
  @home {0, 0}
  @black 0
  @white 1
  @left 0
  @right 1

  def part_one(mem) do
    next(
      @home,
      %{@home => @black},
      @north,
      Computer.new("painter", :array.from_list(mem, @black), [@black])
    )
    |> Map.keys()
    |> Enum.count()
  end

  def part_two(mem) do
    next(
      @home,
      %{@home => @white},
      @north,
      Computer.new("painter", :array.from_list(mem, @black), [@white])
    ) |> print()
  end


  def heading_char(@north), do: "^"
  def heading_char(@south), do: "v"
  def heading_char(@east), do: ">"
  def heading_char(@west), do: "<"

  def print(grid) do
    min_x = grid |> Map.keys |> Enum.map(fn {x, _} -> x end) |> Enum.min()
    max_x = grid |> Map.keys |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    min_y = grid |> Map.keys |> Enum.map(fn {_, y} -> y end) |> Enum.min()
    max_y = grid |> Map.keys |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    for y <- min_y..max_y do
      for x <- -min_x..max_x do
          c =
            case Map.get(grid, {x, y}) do
              0 -> " "
              1 -> "#"
              _ -> "."
            end

          IO.write(c)
        end
      IO.puts("")
      end

      IO.puts("")
  end

  def color_name(@black), do: "black"
  def color_name(@white), do: "white"
  def direction_name(@left), do: "left"
  def direction_name(@right), do: "right"

  def next(location, grid, heading, robot) do

    #IO.inspect(at: location, heading: heading_char(heading))
    case step(robot) do
      {:ok, robot, color, direction} ->
        #IO.inspect(instruction: [set: location, to: color_name(color), and_turn: direction_name(direction)])
        grid = Map.put(grid, location, color)
        #IO.inspect(turning: direction_name(direction))
        {heading, location} = move(location, heading, direction)
        new_location_color = Map.get(grid, location, @black)
        #IO.inspect(moved_to: location, which_is: color_name(new_location_color), now_heading: heading_char(heading))

        robot = robot |> Computer.input([new_location_color])
        #IO.puts("")
        next(location, grid, heading, robot)

      {:ok, :done} ->
        grid
    end
  end

  def step(%Computer{state: :halted, outputs: []}),
    do: {:ok, :done}

  def step(%Computer{state: :idle, outputs: [direction, color]} = computer),
    do: {:ok, %Computer{computer | outputs: []}, color, direction}

  def step(%Computer{state: :idle, outputs: [_direction]} = computer),
    do: step(Computer.execute(computer, after_output: :idle))

  def step(%Computer{state: :idle, outputs: [], inputs: [_]} = computer),
    do: step(Computer.execute(computer, after_output: :idle))

  def turn(@north, @left), do: @west
  def turn(@west, @left), do: @south
  def turn(@south, @left), do: @east
  def turn(@east, @left), do: @north

  def turn(@north, @right), do: @east
  def turn(@east, @right), do: @south
  def turn(@south, @right), do: @west
  def turn(@west, @right), do: @north

  def move({x, y}, heading, direction) do
    new_direction = turn(heading, direction)
    {new_direction, move({x, y}, new_direction)}
  end

  def move({x, y}, {dx, dy}), do: {x + dx, y + dy}
end
