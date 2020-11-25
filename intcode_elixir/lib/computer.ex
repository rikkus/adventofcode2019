require IEx

defmodule Computer do
  @type input :: list(integer)
  @type output :: list(integer)
  @type memory :: :array.array(integer)
  @type instruction_pointer :: non_neg_integer

  defstruct [
    :name,
    :mem,
    :ip,
    :ic,
    :inputs,
    :outputs,
    :state,
    :relative_base,
    :after_output,
    :debug
  ]

  def last_output(%Computer{outputs: outputs}),
    do: outputs |> hd()

  @spec output(Computer.t()) :: list(integer())
  def output(%Computer{outputs: outputs}),
    do: outputs |> Enum.reverse()

  def read_output(%Computer{outputs: [x | xs]} = computer),
    do: {%Computer{computer | outputs: xs}, x}

  def input(%Computer{inputs: inputs} = c, input),
    do: %Computer{c | inputs: inputs ++ input}

  @spec new(name :: String.t(), memory :: memory, input :: input) :: Computer.t()
  def new(name, memory, input) do
    %Computer{
      :name => name,
      :mem => memory,
      :relative_base => 0,
      :ip => 0,
      :ic => 0,
      :inputs => input,
      :outputs => [],
      :state => :idle
    }
  end

  @spec execute(Computer.t(), keyword) :: Computer.t()
  def execute(computer, opts \\ []),
    do:
      do_execute(%Computer{
        computer
        | state: :running,
          after_output: Keyword.get(opts, :after_output, :continue),
          debug: Keyword.get(opts, :debug, false)
      })

  @spec do_execute(Computer.t()) :: Computer.t()
  def do_execute(computer) do
    computer
    |> execute_instruction(Instruction.decode(computer.mem, computer.ip, debug: computer.debug))
  end

  defp execute_instruction(
         %Computer{mem: mem, ip: ip, relative_base: relative_base, debug: debug} = computer,
         {:add, [a, b, x] = args}
       ) do
    log("add #{inspect(a)} and #{inspect(b)} and store at #{inspect(x)}", computer)

    a_ = Memory.read(mem, ip, relative_base, a, debug: debug)
    b_ = Memory.read(mem, ip, relative_base, b, debug: debug)
    mem_ = Memory.write(mem, ip, relative_base, x, a_ + b_, debug: debug)

    %Computer{computer | mem: mem_} |> move_to_next_instruction(args) |> do_execute()
  end

  defp execute_instruction(
         %Computer{mem: mem, ip: ip, relative_base: relative_base, debug: debug} = computer,
         {:multiply, [a, b, x] = args}
       ) do
    log("multiply #{inspect(a)} and #{inspect(b)} and store at #{inspect(x)}", computer)

    a_ = Memory.read(mem, ip, relative_base, a, debug: debug)
    b_ = Memory.read(mem, ip, relative_base, b, debug: debug)
    mem_ = Memory.write(mem, ip, relative_base, x, a_ * b_, debug: debug)

    %Computer{computer | mem: mem_} |> move_to_next_instruction(args) |> do_execute()
  end

  defp execute_instruction(
         %Computer{mem: mem, ip: ip, relative_base: relative_base, inputs: [x | xs], debug: debug} =
           computer,
         {:set, [index] = args}
       ) do
    log("set #{inspect(index)} to #{inspect(x)}", computer)

    %Computer{
      computer
      | mem: Memory.write(mem, ip, relative_base, index, x, debug: debug),
        inputs: xs
    }
    |> move_to_next_instruction(args)
    |> do_execute()
  end

  defp execute_instruction(%Computer{inputs: []} = computer, {:set, [index]}) do
    log("set #{inspect(index)} to ... awaiting input!", computer)
    %Computer{computer | state: :awaiting_input}
  end

  defp execute_instruction(
         %Computer{
           mem: mem,
           ip: ip,
           relative_base: relative_base,
           outputs: outputs,
           after_output: :continue,
           debug: debug
         } = computer,
         {:get, [value] = args}
       ) do
    log("get #{inspect(value)} (then continue)", computer)

    value_ = Memory.read(mem, ip, relative_base, value, debug: debug)

    %Computer{computer | outputs: [value_ | outputs]}
    |> move_to_next_instruction(args)
    |> do_execute()
  end

  defp execute_instruction(
         %Computer{
           mem: mem,
           ip: ip,
           relative_base: relative_base,
           outputs: outputs,
           after_output: :idle,
           debug: debug
         } = computer,
         {:get, [value] = args}
       ) do
    log("get #{inspect(value)} (then idle)", computer)

    value_ = Memory.read(mem, ip, relative_base, value, debug: debug)

    %Computer{computer | outputs: [value_ | outputs], state: :idle}
    |> move_to_next_instruction(args)
  end

  defp execute_instruction(
         %Computer{mem: mem, ip: ip, relative_base: relative_base, ic: ic, debug: debug} =
           computer,
         {:jump_if_one, [a, b]}
       ) do
    log("jump to #{inspect(a)} if #{inspect(b)} != 0", computer)

    a_ = Memory.read(mem, ip, relative_base, a, debug: debug)
    b_ = Memory.read(mem, ip, relative_base, b, debug: debug)

    %Computer{computer | ip: if(a_ != 0, do: b_, else: ip + 3), ic: ic + 1}
    |> do_execute()
  end

  defp execute_instruction(
         %Computer{mem: mem, ip: ip, relative_base: relative_base, ic: ic, debug: debug} =
           computer,
         {:jump_if_zero, [a, b]}
       ) do
    log("jump to #{inspect(a)} if #{inspect(b)} == 0", computer)

    a_ = Memory.read(mem, ip, relative_base, a, debug: debug)
    b_ = Memory.read(mem, ip, relative_base, b, debug: debug)

    %Computer{computer | ip: if(a_ == 0, do: b_, else: ip + 3), ic: ic + 1}
    |> do_execute()
  end

  defp execute_instruction(
         %Computer{mem: mem, ip: ip, relative_base: relative_base, debug: debug} = computer,
         {:set_if_less, [a, b, c] = args}
       ) do
    log("set #{inspect(c)} to 1 if #{inspect(a)} < #{inspect(b)}, else 0", computer)

    a_ = Memory.read(mem, ip, relative_base, a, debug: debug)
    b_ = Memory.read(mem, ip, relative_base, b, debug: debug)
    mem_ = Memory.write(mem, ip, relative_base, c, if(a_ < b_, do: 1, else: 0))

    %Computer{computer | mem: mem_} |> move_to_next_instruction(args) |> do_execute()
  end

  defp execute_instruction(
         %Computer{mem: mem, ip: ip, relative_base: relative_base, debug: debug} = computer,
         {:set_if_equal, [a, b, c] = args}
       ) do
    log("set #{inspect(c)} to 1 if #{inspect(a)} == #{inspect(b)}, else 0", computer)

    a_ = Memory.read(mem, ip, relative_base, a, debug: debug)
    b_ = Memory.read(mem, ip, relative_base, b, debug: debug)
    mem_ = Memory.write(mem, ip, relative_base, c, if(a_ == b_, do: 1, else: 0))

    %Computer{computer | mem: mem_} |> move_to_next_instruction(args) |> do_execute()
  end

  defp execute_instruction(
         %Computer{mem: mem, ip: ip, relative_base: relative_base, debug: debug} = computer,
         {:adjust_relative_base, [offset] = args}
       ) do
    log("adjust relative base from #{relative_base}, by #{inspect(offset)}", computer)

    offset_ = Memory.read(mem, ip, relative_base, offset, debug: debug)

    %Computer{computer | relative_base: relative_base + offset_}
    |> move_to_next_instruction(args)
    |> do_execute()
  end

  defp execute_instruction(computer, {:halt, _}) do
    log("hlt", computer)
    %Computer{computer | state: :halted} |> move_to_next_instruction([])
  end

  defp execute_instruction(computer, {other, modes}),
    do:
      raise(
        "bad instruction: #{other} (modes = #{inspect(modes, charlists: :as_lists)}) (computer = #{
          inspect(computer)
        }"
      )

  defp move_to_next_instruction(%Computer{ip: ip, ic: ic} = computer, args),
    do: %Computer{computer | ip: ip + length(args) + 1, ic: ic + 1}

  defp log(_, %Computer{debug: false}),
    do: nil

  defp log(x, %Computer{name: name, ic: ic}),
    do: IO.puts("#{name} #{ic}: #{inspect(x)}")
end
