defmodule Instruction do
  @opcode %{
    1 => :add,
    2 => :multiply,
    3 => :set,
    4 => :get,
    5 => :jump_if_one,
    6 => :jump_if_zero,
    7 => :set_if_less,
    8 => :set_if_equal,
    9 => :adjust_relative_base,
    99 => :halt
  }

  @opcode_value %{
    :add => 1,
    :multiply => 2,
    :set => 3,
    :get => 4,
    :jump_if_one => 5,
    :jump_if_zero => 6,
    :set_if_less => 7,
    :set_if_equal => 8,
    :adjust_relative_base => 9,
    :halt => 99
  }

  @spec argument_modes([0 | 1 | 2, ...]) :: [:immediate | :position | :relative, ...]
  def argument_modes([a1]), do: [ Memory.addressing_mode(a1), :position, :immediate ]
  def argument_modes([a1, a2]), do: [ Memory.addressing_mode(a1), Memory.addressing_mode(a2), :immediate ]
  def argument_modes([a1, a2, a3]), do: [ Memory.addressing_mode(a1), Memory.addressing_mode(a2), Memory.addressing_mode(a3) ]

  def decode(mem, ip, opts \\ []) do
    instruction = :array.get(ip, mem)
    instruction_digits = Integer.digits(instruction) |> Enum.reverse()

    log("-----------------------------------------------------------------", opts)
    log("decode:  instruction: #{instruction}", opts)
    log("         digits: #{inspect(instruction_digits, charlists: :as_lists)}", opts)

    opcode = opcode(instruction_digits)
    instruction_modes = instruction_digits |> Enum.drop(2) |> mode_numbers_to_modes()

    log("         opcode: #{opcode_to_number(opcode)} (#{opcode})", opts)
    log("         instruction_modes: #{inspect(instruction_modes)}", opts)

    args = args_required(opcode) |> Enum.map(fn offset -> arg(mem, ip, offset, instruction_modes, opts) end)

    log("         args: #{inspect(args)}", opts)
    log("", opts)

    {opcode, args}
  end

  defp arg(mem, ip, offset, instruction_modes, opts),
    do: { Memory.fetch(mem, ip + 1 + offset, opts), Enum.at(instruction_modes, offset, :position) }

  def mode_numbers_to_modes(mode_numbers),
    do:
      mode_numbers
      |> Enum.map(fn mode -> Memory.addressing_mode(mode) end)

  def opcode([o1, o2 | _]), do: opcode_for_numbers(o1, o2)
  def opcode([o1]), do: opcode_for_numbers(o1, 0)

  def opcode_to_number(opcode),
    do: Map.get(@opcode_value, opcode)

  def number_to_opcode(value),
    do: Map.get(@opcode, value)

  def opcode_for_numbers(digit1, digit2),
    do: number_to_opcode(digit2 * 10 + digit1)

  def args_required(:add), do: [0, 1, 2]
  def args_required(:multiply), do: [0, 1, 2]
  def args_required(:set), do: [0]
  def args_required(:get), do: [0]
  def args_required(:jump_if_one), do: [0, 1]
  def args_required(:jump_if_zero), do: [0, 1]
  def args_required(:set_if_less), do: [0, 1, 2]
  def args_required(:set_if_equal), do: [0, 1, 2]
  def args_required(:adjust_relative_base), do: [0]
  def args_required(_), do: []

  def log(message, opts) do
    debug = Keyword.get(opts, :debug, false)

    if debug do
      IO.puts(message)
    end
  end
end
