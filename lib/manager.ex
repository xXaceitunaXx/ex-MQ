defmodule ExMq.Manager do

  def create(name) do
    case Registry.lookup(:queue_registry, name) do
      []  -> via_name(name) |> ExMq.Queue.Supervisor.create_queue
      _   -> {:error, "Name #{name} is already taken"}
    end
  end

  def delete(name) do
    case Registry.lookup(:queue_registry, name) do
      [{pid, _}]  -> ExMq.Queue.Supervisor.delete_queue pid
      []          -> {:error, "No queue for name #{name}"}
    end
  end

  def enqueue(name, message) do
    case Registry.lookup(:queue_registry, name) do
      [_] -> via_name(name) |> ExMq.Queue.enqueue(message)
      []  -> {:error, "No queue for name #{name}"}
    end
  end

  def dequeue(name) do
    case Registry.lookup(:queue_registry, name) do
      [_] -> via_name(name) |> ExMq.Queue.dequeue
      []  -> {:error, "No queue for name #{name}"}
    end
  end

  def peek(name) do
    case Registry.lookup(:queue_registry, name) do
      [_] -> via_name(name) |> ExMq.Queue.peek
      []  -> {:error, "No queue for name #{name}"}
    end
  end

  def names(), do: Registry.select(:queue_registry, [{{:"$1", :_, :_}, [], [:"$1"]}])

  defp via_name(name), do: {:via, Registry, {:queue_registry, name}}
end
