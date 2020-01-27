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
      Computer.new("painter", :array.from_list(mem, 0), [0])
    )
  end

  def heading_char(@north), do: "^"
  def heading_char(@south), do: "v"
  def heading_char(@east), do: ">"
  def heading_char(@west), do: "<"

  def print(location, grid, heading) do
    for y <- -5..5 do
      for x <- -5..5 do
        if {x, y} == location do
          IO.write(heading_char(heading))
        else
          c =
            case Map.get(grid, {x, y}) do
              0 -> "#"
              1 -> "O"
              _ -> "."
            end

          IO.write(c)
        end
      end

      IO.puts("")
    end

    IO.puts("")
  end

  def color_name(@black), do: "black"
  def color_name(@white), do: "white"
  def direction_char(@left), do: "left"
  def direction_char(@right), do: "right"

  def next(location, grid, heading, robot) do
    # print(location, grid, heading)

    case step(robot) do
      {:ok, robot, color, direction} ->
        IO.inspect(
          color: color_name(color),
          direction: direction_char(direction),
          inputs: robot.inputs
        )

        grid = Map.put(grid, location, color)
        {location, heading} = move(location, heading, direction)

        robot = robot |> Computer.input([Map.get(grid, location, @white)])
        next(location, grid, heading, robot)

      {:ok, :done} ->
        grid

      what ->
        IO.inspect(what)
        nil
    end
  end

  def step(robot) do
    robot
    |> Computer.execute(after_output: :idle, debug: false)
    |> Computer.execute(after_output: :idle, debug: false)
    |> analyse()
  end

  def analyse(%Computer{state: :halted}), do: {:ok, :done}

  def analyse(computer) do
    {computer, color} = Computer.read_output(computer)
    {computer, direction} = Computer.read_output(computer)
    {:ok, computer, color, direction}
  end

  def move({x, y}, heading, @left) do
    case heading do
      @north -> {{x + 1, y}, @west}
      @south -> {{x - 1, y}, @east}
      @east -> {{x, y + 1}, @south}
      @west -> {{x, y - 1}, @north}
    end
  end

  def move({x, y}, heading, @right) do
    case heading do
      @north -> {{x + 1, y}, @east}
      @south -> {{x - 1, y}, @west}
      @east -> {{x, y + 1}, @north}
      @west -> {{x, y - 1}, @south}
    end
  end
end
