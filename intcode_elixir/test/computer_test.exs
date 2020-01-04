defmodule ComputerTest do
  use ExUnit.Case

  test "instruction with opcode add", do: assert(Instruction.opcode([1]) == :add)
  test "instruction with opcode multiply", do: assert(Instruction.opcode([2]) == :multiply)
  test "instruction with opcode halt", do: assert(Instruction.opcode([9, 9]) == :halt)

  test "instruction with opcode add, plus some modes",
    do: assert(Instruction.opcode([1, 0, 1, 1, 1]) == :add)

  test "instruction with opcode multiply, plus some modes",
    do: assert(Instruction.opcode([2, 0, 1, 1, 1]) == :multiply)

  test "instruction with opcode halt, plus some modes",
    do: assert(Instruction.opcode([9, 9, 1, 1, 1]) == :halt)

  def run(mem, opts \\ []),
    do:
      Computer.new("", :array.from_list(mem), [])
      |> Computer.execute(opts)
      |> Computer.output()

  test """
       Adjust relative base by -1 (so is now -1)
       Get 'position', i.e. mem[mem[3]]
       """,
       do: assert(run([109, -1, 4, 1, 99]) == [-1])

  test """
       Adjust relative base by -1 (so is now -1)
       Get 'immediate', i.e. mem[3]
       """,
       do: assert(run([109, -1, 104, 1, 99]) == [1])

  test """
       Adjust relative base by -1 (so is now -1)
       Get 'relative', i.e. mem[mem[3 + relative_base]]
       """,
       do: assert(run([109, -1, 204, 1, 99]) == [109])

  test """
       Adjust relative base by 1 (so is now 1)
       Adjust relative base by mem[2] (so is now 1 + 9 = 10)
       Get 'relative', i.e. mem[mem[-6 + relative_base]] (-6 + 10 = 4) - mem[4] == 204
       """,
       do: assert(run([109, 1, 9, 2, 204, -6, 99], debug: true) == [204])

  test """
       Adjust relative base by 1 (so is now 1)
       Adjust relative base by 9 (so is now 1 + 9 = 10)
       Get 'relative', i.e. mem[mem[-6 + relative_base]] (-6 + 10 = 4) - mem[4] == 204
       """,
       do: assert(run([109, 1, 109, 9, 204, -6, 99]) == [204])

  test """
       Adjust relative base by 1 (so is now 1)
       Adjust relative base by mem[-1 + 1] (so is 1 + 109 = 110)
       Get 'relative', i.e. mem[mem[-106 + relative_base]] (-106 + 110) - mem[4] == 204
       """,
       do: assert(run([109, 1, 209, -1, 204, -106, 99]) == [204])

  test """
  Adjust relative base by 1 (so is now 1)
  Set mem[3] (add 3 as input)
  Get 'relative', i.e. mem[2 + relative_base(1)] == mem[3] == 1
  """ do
    memory = [109, 1, 3, 3, 204, 2, 99]

    output =
      Computer.new("", :array.from_list(memory), [1])
      |> Computer.execute(debug: true)
      |> Computer.output()

    assert output == [1]
  end

  test """
  Adjust relative base by 1 (so is now 1)
  Set mem[]
  ...
  Get 'relative', i.e. mem[mem[2 + relative_base]] (2 + 1) == mem[3]
  """ do
    memory = [109, 1, 203, 2, 204, 2, 99]

    output =
      Computer.new("", :array.from_list(memory), [1])
      |> Computer.execute(debug: true)
      |> Computer.output()

    assert output == [1]
  end

  test """
  print 42 if 209 bugged
  """ do
    memory = [109,1,203,11,209,8,204,1,99,10,0,42,0]

    output =
      Computer.new("", :array.from_list(memory), [1])
      |> Computer.execute(debug: true)
      |> Computer.output()

    assert output == [1]
  end

  test "" do
    #w :w Instruction.decode(:array.from_list(11101), 0, 0)
  end

end
