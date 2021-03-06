defmodule Computer do
  @type input :: list(integer)
  @type output :: list(integer)
  @type memory :: :array.array(integer)
  @type instruction_pointer :: non_neg_integer

  defstruct [:mem, :ip, :inputs, :outputs, :debug]

  @add 1
  @mul 2
  @set 3
  @get 4
  @jit 5
  @jif 6
  @les 7
  @equ 8
  @hlt 99
  @position 0
  @immediate 1

  def opcode_name(@add), do: "Add"
  def opcode_name(@mul), do: "Mul"
  def opcode_name(@set), do: "In_"
  def opcode_name(@get), do: "Out"
  def opcode_name(@hlt), do: "Hlt"
  def opcode_name(@jit), do: "Jit"
  def opcode_name(@jif), do: "Jif"
  def opcode_name(@les), do: "Les"
  def opcode_name(@equ), do: "Equ"

  @default_modes %{1 => @position, 2 => @position, 3 => @immediate}

  def memory(%Computer{mem: mem}), do: mem
  def outputs(%Computer{outputs: outputs}), do: outputs

  @spec new(memory :: memory, input :: input, debug :: boolean()) :: Computer.t()
  def new(memory, input, debug \\ false),
    do: %Computer{:mem => memory, :ip => 0, :inputs => input, :outputs => [], :debug => debug}

  @spec execute(Computer.t()) :: Computer.t()
  def execute(computer),
    do: do_execute(computer)

  @spec do_execute(Computer.t()) :: Computer.t()
  def do_execute(%Computer{mem: mem, ip: ip} = computer) do
    {opcode, args} = decode(mem, ip)
    execute_instruction(opcode, args, computer)
  end

  defp execute_instruction(@add, [a, b, x], %Computer{mem: mem, ip: ip} = computer) do
    log("add #{a} to #{b} and store at #{x}", computer)

    %Computer{computer | mem: write(mem, x, a + b), ip: ip + 4}
    |> do_execute
  end

  defp execute_instruction(@mul, [a, b, x], %Computer{mem: mem, ip: ip} = computer) do
    log("multiply #{a} and #{b} and store at #{x}", computer)

    %Computer{computer | mem: write(mem, x, a * b), ip: ip + 4}
    |> do_execute()
  end

  defp execute_instruction(
         @set,
         [index],
         %Computer{mem: mem, ip: ip, inputs: [i | inputs]} = computer
       ) do
    log("set #{index} to #{i}", computer)

    %Computer{computer | mem: write(mem, index, i), inputs: inputs, ip: ip + 2}
    |> do_execute()
  end

  defp execute_instruction(@get, [value], %Computer{ip: ip, outputs: outputs} = computer) do
    log("get #{value}", computer)

    %Computer{computer | outputs: [value | outputs], ip: ip + 2}
    |> do_execute()
  end

  defp execute_instruction(@jit, [a, b], %Computer{ip: ip} = computer) do
    log("jump to #{a} if #{b} != 0", computer)

    %Computer{computer | ip: if(a != 0, do: b, else: ip + 3)}
    |> do_execute()
  end

  defp execute_instruction(@jif, [a, b], %Computer{ip: ip} = computer) do
    log("jump to #{a} if #{b} == 0", computer)

    %Computer{computer | ip: if(a == 0, do: b, else: ip + 3)}
    |> do_execute()
  end

  defp execute_instruction(@les, [a, b, c], %Computer{mem: mem, ip: ip} = computer) do
    log("set #{c} to 1 if #{a} < #{b}, else 0", computer)

    %Computer{computer | mem: write(mem, c, if(a < b, do: 1, else: 0)), ip: ip + 4}
    |> do_execute()
  end

  defp execute_instruction(@equ, [a, b, c], %Computer{mem: mem, ip: ip} = computer) do
    log("set #{c} to 1 if #{a} == #{b}, else 0", computer)

    %Computer{computer | mem: write(mem, c, if(a == b, do: 1, else: 0)), ip: ip + 4}
    |> do_execute()
  end

  defp execute_instruction(@hlt, _, computer), do: computer

  defp execute_instruction(other, _modes, _computer), do: raise("bad instruction: #{other}")

  defp decode(mem, ip) do
    # log([:decode, mem: mem, ip: ip])
    n = :array.get(ip, mem)
    digits = Integer.digits(n) |> Enum.reverse()

    opcode = opcode(digits)

    args =
      case opcode do
        @set ->
          args_required(opcode)
          |> Enum.map(fn offset -> fetch(mem, ip, offset, %{1 => @immediate}) end)

        _ ->
          args_required(opcode)
          |> Enum.map(fn offset -> fetch(mem, ip, offset, modes(digits)) end)
      end

    {opcode, args}
  end

  defp opcode([o1, o2 | _]), do: opcode(o1, o2)
  defp opcode([o1]), do: opcode(o1, 0)

  defp modes([_, _ | modes]), do: modes |> mode_map
  defp modes(_), do: @default_modes

  defp args_required(@add), do: [1, 2, 3]
  defp args_required(@mul), do: [1, 2, 3]
  defp args_required(@set), do: [1]
  defp args_required(@get), do: [1]
  defp args_required(@jit), do: [1, 2]
  defp args_required(@jif), do: [1, 2]
  defp args_required(@les), do: [1, 2, 3]
  defp args_required(@equ), do: [1, 2, 3]
  defp args_required(_), do: []

  defp opcode(@add, 0), do: @add
  defp opcode(@mul, 0), do: @mul
  defp opcode(@set, 0), do: @set
  defp opcode(@get, 0), do: @get
  defp opcode(@jit, 0), do: @jit
  defp opcode(@jif, 0), do: @jif
  defp opcode(@les, 0), do: @les
  defp opcode(@equ, 0), do: @equ
  defp opcode(9, 9), do: @hlt

  def fetch(mem, index),
    do: :array.get(index, mem)

  @spec fetch(:array.array(any), non_neg_integer, integer, 0 | 1 | Map.t()) :: any
  def fetch(mem, ip, offset, @immediate),
    do: fetch(mem, ip + offset)

  def fetch(mem, ip, offset, @position),
    do: fetch(mem, fetch(mem, ip + offset))

  def fetch(mem, ip, offset, modes), do: fetch(mem, ip, offset, modes[offset])

  defp mode_map(modes),
    do: @default_modes |> Map.merge([1, 2, 3] |> Enum.zip(modes) |> Map.new())

  defp write(mem, index, value),
    do: :array.set(index, value, mem)

  defp log(_, %Computer{debug: false}),
    do: nil

  defp log(x, %Computer{debug: true}),
    do: IO.inspect(x)
end
