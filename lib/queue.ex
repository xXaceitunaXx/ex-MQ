defmodule ExMq.Queue do
  use GenServer

  defstruct [:name, :queue]

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def init(name), do: {:ok, %{name: name, queue: Qex.new}}

  # API

  def enqueue(name, message), do: GenServer.call(name, {:enqueue, message})

  def dequeue(name), do: GenServer.call(name, :dequeue)

  def peek(name), do: GenServer.call(name, :peek)

  # Handlers

  def handle_call({:enqueue, message}, _from, state) do
    n_q = Qex.push state.queue, message
    {:reply, :ok, %{state | queue: n_q}}
  end

  def handle_call(:dequeue, _from, state) do
    {result, n_q} = Qex.pop state.queue
    {:reply, result, %{state | queue: n_q}}
  end

  def handle_call(:peek, _from, state) do
    result = Qex.first state.queue
    {:reply, result, state}
  end

  def handle_call(:name, _from, state) do # Necesario? veremos xd
    {:reply, {:ok, state.name}, state}
  end
end
