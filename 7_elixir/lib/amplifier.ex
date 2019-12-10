defmodule Amplifier do
  @type input :: list(integer)
  @type output :: list(integer)
  @type memory :: :array.array(integer)
  @type instruction_pointer :: non_neg_integer

  defstruct [:mem, :ip, :inputs, :outputs]

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
  def opcode_name(@set), do: "In"
  def opcode_name(@get), do: "Out"
  def opcode_name(@hlt), do: "Hlt"
  def opcode_name(@jit), do: "Jit"
  def opcode_name(@jif), do: "Jif"
  def opcode_name(@les), do: "Les"
  def opcode_name(@equ), do: "Equ"

  @default_modes %{1 => @position, 2 => @position, 3 => @immediate}

  @spec execute(memory, input) :: {memory, output}
  def execute(mem, inputs),
   do: do_execute(%Amplifier{:mem => mem, :ip => 0, :inputs => inputs, :outputs => []})

  @spec do_execute(Amplifier.t()) :: {memory, output}
  def do_execute(%Amplifier{mem: mem, ip: ip} = state) do
    {opcode, args} = decode(mem, ip)
    execute_instruction(opcode, args, state)
  end

  defp execute_instruction(@add, [a, b, x], %Amplifier{mem: mem, ip: ip} = state) do
    IO.puts "add #{a} to #{b} and store at #{x}"
    %Amplifier{state | mem: write(mem, x, a + b), ip: ip + 4}
    |> do_execute
  end

  defp execute_instruction(@mul, [a, b, x], %Amplifier{mem: mem, ip: ip} = state) do
    IO.puts "multiply #{a} and #{b} and store at #{x}"
    %Amplifier{state | mem: write(mem, x, a * b), ip: ip + 4}
    |> do_execute
  end

  defp execute_instruction(@set, [index], %Amplifier{mem: mem, ip: ip, inputs: [i | inputs]} = state) do
    IO.puts "set #{index} to #{i}"
    %Amplifier{state | mem: write(mem, index, i), inputs: inputs, ip: ip + 2}
    |> do_execute
  end

  defp execute_instruction(@get, [value], %Amplifier{ip: ip, outputs: outputs} = state) do
    IO.puts "get #{value}"
    %Amplifier{state | outputs: [value | outputs], ip: ip + 2}
  end

  defp execute_instruction(@jit, [a, b], %Amplifier{ip: ip} = state) do
    IO.puts "jump to #{a} if #{b} != 0"
    %Amplifier{state | ip: (if a != 0, do: b, else: ip + 3)}
    |> do_execute
  end

  defp execute_instruction(@jif, [a, b], %Amplifier{ip: ip} = state) do
    IO.puts "jump to #{a} if #{b} == 0"
    %Amplifier{state | ip: (if a == 0, do: b, else: ip + 3)}
    |> do_execute
  end

  defp execute_instruction(@les, [a, b, c], %Amplifier{mem: mem, ip: ip} = state) do
    IO.puts "set #{c} to 1 if #{a} < #{b}, else 0"
    %Amplifier{state | mem: write(mem, c, (if a < b, do: 1, else: 0)), ip: ip + 4}
    |> do_execute
  end

  defp execute_instruction(@equ, [a, b, c], %Amplifier{mem: mem, ip: ip} = state) do
    IO.puts "set #{c} to 1 if #{a} == #{b}, else 0"
    %Amplifier{state | mem: write(mem, c, (if a == b, do: 1, else: 0)), ip: ip + 4}
    |> do_execute
  end

  defp execute_instruction(@hlt, _, %Amplifier{mem: mem, outputs: outputs}),
    do: {mem, outputs}

  defp execute_instruction(other, _modes, _state),
    do: raise "bad instruction: #{other}"

  defp decode(mem, ip) do

    digits = Integer.digits(:array.get(ip, mem)) |> Enum.reverse

    opcode = opcode(digits)
    args = case opcode do
      @set -> args_required(opcode) |> Enum.map(fn offset -> fetch(mem, ip, offset, %{1 => @immediate}) end)
      _ -> args_required(opcode) |> Enum.map(fn offset -> fetch(mem, ip, offset, modes(digits)) end)
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
end
