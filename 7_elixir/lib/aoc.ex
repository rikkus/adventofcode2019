defmodule Aoc do
   def part_one(mem) do
      permutations([0, 1, 2, 3, 4])
      |> Enum.map(fn combo ->
       {_, ret} = execute_combo(:array.from_list(mem), 0, combo)
       ret
       end)
      |> Enum.max()
   end

   def execute_combo(mem, input_signal, []) do
    {mem, input_signal}
   end

   def execute_combo(mem, input_signal, [x | xs]) do
    {mem, ret} = Amplifier.execute(mem, [x, input_signal])
    execute_combo(mem, ret |> hd(), xs)
   end


   def part_two(mem) do
      permutations([5, 6, 7, 8, 9])
      |> Enum.map(fn permutation -> do_part_two(mem, permutation) end)
      |> Enum.max()
   end

   def do_part_two(mem, [p1, p2, p3, p4, p5]) do

    {:ok, amp_a} = AmpServer.start_link(:array.from_list(mem))
    {:ok, amp_b} = AmpServer.start_link(:array.from_list(mem))
    {:ok, amp_c} = AmpServer.start_link(:array.from_list(mem))
    {:ok, amp_d} = AmpServer.start_link(:array.from_list(mem))
    {:ok, amp_e} = AmpServer.start_link(:array.from_list(mem))

    :ok = AmpServer.join(amp_a, amp_b)
    :ok = AmpServer.join(amp_b, amp_c)
    :ok = AmpServer.join(amp_c, amp_d)
    :ok = AmpServer.join(amp_d, amp_e)
    :ok = AmpServer.join(amp_e, amp_a)

    :ok = AmpServer.add(amp_a, p1)
    :ok = AmpServer.add(amp_b, p2)
    :ok = AmpServer.add(amp_c, p3)
    :ok = AmpServer.add(amp_d, p4)
    :ok = AmpServer.add(amp_e, p5)

    :ok = AmpServer.execute(amp_a)

   end

  def permutations(l),
    do: do_permutations(l, [], [])

  defp do_permutations([], x, acc),
    do: [x | acc]

  defp do_permutations(list, x, acc) do
    list
    |> Stream.unfold(fn [x | xs] -> {{x, xs}, xs ++ [x]} end)
    |> Enum.take(length(list))
    |> Enum.reduce(acc, fn {h, t}, acc -> do_permutations(t, [h | x], acc) end)
  end
end
