defmodule Computer do
  @type input :: list(integer)
  @type output :: list(integer)
  @type memory :: :array.array(integer)
  @type instruction_pointer :: non_neg_integer

  defstruct [:mem, :ip, :inputs, :outputs, :debug, :state, :name, :relative_base, :ic, :after_output]

  @add 1
  @mul 2
  @set 3
  @get 4
  @jit 5
  @jif 6
  @les 7
  @equ 8
  @arb 9
  @hlt 99
  @position 0
  @immediate 1
  @relative 2

  @type addressing_mode :: 0 | 1 | 2

  def opcode_name(@add), do: "ADD"
  def opcode_name(@mul), do: "MUL"
  def opcode_name(@set), do: "INP"
  def opcode_name(@get), do: "OUT"
  def opcode_name(@hlt), do: "HLT"
  def opcode_name(@jit), do: "JIT"
  def opcode_name(@jif), do: "JIF"
  def opcode_name(@les), do: "LES"
  def opcode_name(@equ), do: "EQU"
  def opcode_name(@arb), do: "ARB"

  @default_modes %{1 => @position, 2 => @position, 3 => @immediate}

  def last_output(%Computer{outputs: outputs}),
    do: outputs |> hd()

  def output(%Computer{outputs: outputs}),
    do: outputs |> Enum.reverse()

  def input(%Computer{inputs: inputs} = c, input),
    do: %Computer{c | inputs: inputs ++ input}

  @spec new(name :: String.t(), memory :: memory, input :: input, opts :: list(keyword())) ::
          Computer.t()
  def new(name, memory, input, opts \\ []) do
    %Computer{
      :name => name,
      :mem => memory,
      :relative_base => 0,
      :ip => 0,
      :ic => 0,
      :inputs => input,
      :outputs => [],
      :state => :idle,
      :after_output => Keyword.get(opts, :after_output, :continue),
      :debug => Keyword.get(opts, :debug, false)
    }
  end

  @spec execute(Computer.t()) :: Computer.t()
  def execute(computer, opts \\ []),
    do: do_execute(
      %Computer{ computer |
         state: :running,
        after_output: Keyword.get(opts, :after_output, :continue),
        debug: Keyword.get(opts, :debug, false)
    })

  @spec do_execute(Computer.t()) :: Computer.t()
  def do_execute(%Computer{debug: debug?} = computer) do
    {opcode, args} = decode(computer)

    if debug? do
      # IO.puts("#{computer.name} executing... opcode: #{opcode}, args: #{inspect(args)}")
    end

    execute_instruction(opcode, args, computer)
  end

  defp execute_instruction(@add, [a, b, x] = args, %Computer{mem: mem} = computer) do
    log("add #{a} to #{b} and store at #{x}", computer)

    %Computer{computer | mem: write(mem, x, a + b)}
    |> move_to_next_instruction(args)
    |> do_execute()
  end

  defp execute_instruction(@mul, [a, b, x] = args, %Computer{mem: mem} = computer) do
    log("multiply #{a} and #{b} and store at #{x}", computer)

    %Computer{computer | mem: write(mem, x, a * b)}
    |> move_to_next_instruction(args)
    |> do_execute()
  end

  defp execute_instruction(@set, [index] = args, %Computer{mem: mem, inputs: [i | inputs]} = computer
       ) do
    log("set #{index} to #{i}", computer)

    %Computer{computer | mem: write(mem, index, i), inputs: inputs}
    |> move_to_next_instruction(args)
    |> do_execute()
  end

  defp execute_instruction(@set, [index], %Computer{inputs: []} = computer) do
    log("set #{index} to ... awaiting input!", computer)
    %Computer{computer | state: :awaiting_input}
  end

  defp execute_instruction(@get, [value] = args, %Computer{outputs: outputs, after_output: :continue} = computer) do
    log("get #{value} (then continue)", computer)
    %Computer{computer | outputs: [value | outputs]}
    |> move_to_next_instruction(args)
    |> do_execute()
  end

  defp execute_instruction(@get, [value] = args, %Computer{outputs: outputs, after_output: :idle} = computer) do
    log("get #{value} (then idle)", computer)
    %Computer{computer | outputs: [value | outputs], state: :idle}
    |> move_to_next_instruction(args)
  end

  defp execute_instruction(@jit, [a, b], %Computer{ip: ip, ic: ic} = computer) do
    log("jump to #{a} if #{b} != 0", computer)

    %Computer{computer | ip: if(a != 0, do: b, else: ip + 3), ic: ic + 1}
    |> do_execute()
  end

  defp execute_instruction(@jif, [a, b], %Computer{ip: ip, ic: ic} = computer) do
    log("jump to #{a} if #{b} == 0", computer)

    %Computer{computer | ip: if(a == 0, do: b, else: ip + 3), ic: ic + 1}
    |> do_execute()
  end

  defp execute_instruction(@les, [a, b, c] = args, %Computer{mem: mem} = computer) do
    log("set #{c} to 1 if #{a} < #{b}, else 0", computer)

    %Computer{computer | mem: write(mem, c, if(a < b, do: 1, else: 0))}
    |> move_to_next_instruction(args)
    |> do_execute()
  end

  defp execute_instruction(@equ, [a, b, c] = args, %Computer{mem: mem} = computer) do
    log("set #{c} to 1 if #{a} == #{b}, else 0", computer)

    %Computer{computer | mem: write(mem, c, if(a == b, do: 1, else: 0))}
    |> move_to_next_instruction(args)
    |> do_execute()
  end

  defp execute_instruction(@arb, [value] = args, %Computer{relative_base: rb} = computer) do
    log("adjust relative base from #{rb}, by #{value}, to #{rb + value}", computer)

    %Computer{computer | relative_base: rb + value}
    |> move_to_next_instruction(args)
    |> do_execute()
  end

  defp execute_instruction(@hlt, _, %Computer{ic: ic} = computer) do
    log("hlt", computer)
    %Computer{computer | state: :halted, ic: ic + 1} |> move_to_next_instruction([])
  end

  defp execute_instruction(other, modes, computer),
    do:
      raise(
        "bad instruction: #{other} (modes = #{inspect(modes, charlists: :as_lists)}) (computer = #{
          inspect(computer)
        }"
      )

  defp move_to_next_instruction(%Computer{ip: ip, ic: ic} = computer, args),
    do: %Computer{computer | ip: ip + length(args) + 1, ic: ic + 1}

  defp decode(%Computer{mem: mem, ip: ip, relative_base: relative_base}) do

    digits = Integer.digits(:array.get(ip, mem)) |> Enum.reverse()
    opcode = opcode(digits)
    modes = modes(opcode, digits)

    args =
      args_required(opcode)
      |> Enum.map(fn offset -> fetch(mem, ip, offset, relative_base, modes) end)

    #log([decode: {mem, ip}, result: {opcode, args}], c)

    {opcode, args}
  end

  defp opcode([o1, o2 | _]), do: opcode(o1, o2)
  defp opcode([o1]), do: opcode(o1, 0)

  defp modes(@set, [3, 0, 2]) do
    %{1 => @position}
  end
  defp modes(@set, _) do
    %{1 => @immediate}
  end
  defp modes(_opcode, [_, _ | modes]), do: mode_map(modes)
  defp modes(_opcode, _), do: @default_modes

  defp args_required(@add), do: [1, 2, 3]
  defp args_required(@mul), do: [1, 2, 3]
  defp args_required(@set), do: [1]
  defp args_required(@get), do: [1]
  defp args_required(@jit), do: [1, 2]
  defp args_required(@jif), do: [1, 2]
  defp args_required(@les), do: [1, 2, 3]
  defp args_required(@equ), do: [1, 2, 3]
  defp args_required(@arb), do: [1]
  defp args_required(_), do: []

  defp opcode(@add, 0), do: @add
  defp opcode(@mul, 0), do: @mul
  defp opcode(@set, 0), do: @set
  defp opcode(@get, 0), do: @get
  defp opcode(@jit, 0), do: @jit
  defp opcode(@jif, 0), do: @jif
  defp opcode(@les, 0), do: @les
  defp opcode(@equ, 0), do: @equ
  defp opcode(@arb, 0), do: @arb
  defp opcode(9, 9), do: @hlt

  def fetch(mem, index) do
    # IO.puts("Fetching from #{inspect(:array.to_list(mem))} at #{index}")
    ret = :array.get(index, mem)
    # IO.puts("Fetched #{ret}")
    ret
  end

  @spec fetch(:array.array(any), non_neg_integer, integer, integer, addressing_mode | Map.t()) ::
          any
  def fetch(mem, ip, offset, _relative_base, @immediate) do
    # IO.puts("fetch immediate at ip (#{ip}) + offset (#{offset}) = #{ip + offset}")
    fetch(mem, ip + offset)
  end

  def fetch(mem, ip, offset, _relative_base, @position) do
    # IO.puts("fetch position at ip (#{ip}) + offset (#{offset}) = #{ip + offset}")
    # IO.write(" -> ")
    fetch(mem, fetch(mem, ip + offset))
  end

  def fetch(mem, ip, offset, relative_base, @relative) do
    # IO.puts("fetch relative: ip = #{ip}, offset = #{offset}, relative_base = #{relative_base}")
    # IO.write(" -> ")
    fetch(mem, relative_base + fetch(mem, ip + offset))
  end

  def fetch(mem, ip, offset, relative_base, modes),
    do: fetch(mem, ip, offset, relative_base, modes[offset])

  defp mode_map(modes),
    do: @default_modes |> Map.merge([1, 2, 3] |> Enum.zip(modes) |> Map.new())

  defp write(mem, index, value),
    do: :array.set(index, value, mem)

  defp log(_, %Computer{debug: false}),
    do: nil

  defp log(x, %Computer{name: name, ic: ic}),
    do: IO.puts("#{name} #{ic}: #{inspect(x)}")
end
