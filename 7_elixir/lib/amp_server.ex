defmodule AmpServer do
  use GenServer
  defstruct [:input, :output, :memory, :downstream]

  defp new_state(memory) do
    %AmpServer{input: :queue.new(), output: :queue.new(), memory: memory, downstream: nil}
  end

  def init(x) do
    {:ok, x}
  end

  def start_link(memory) do
    GenServer.start_link(__MODULE__, new_state(memory))
  end

  def join(pid, downstream) do
    GenServer.call(pid, {:join, downstream})
  end

  def add(pid, item) do
    GenServer.call(pid, {:add, item})
  end

  def execute(pid) do
    GenServer.call(pid, :execute)
  end

  def fetch(pid) do
    GenServer.call(pid, :fetch)
  end

  def handle_call({:add, item}, _from, %AmpServer{input: input} = state) do
    {:reply, :ok, %{state | input: :queue.in(item, input)}}
  end

  def handle_call(:fetch, _from, %AmpServer{output: output} = state) do
    with {{:value, item}, new_output} <- :queue.out(output) do
      {:reply, item, %{state | output: new_output}}
    else
      {:empty, _} ->
        {:reply, :empty, state}
    end
  end

  def handle_call({:join, downstream}, _from, state) do
    {:reply, :ok, %{state | downstream: downstream}}
  end

  def handle_call(:execute, _from, _state) do
    # {:reply, :ok, Computer.execute()}
  end
end
