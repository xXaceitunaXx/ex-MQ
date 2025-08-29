defmodule ExMq.Queue.Supervisor do
  use DynamicSupervisor

  def start_link(_arg) do
    DynamicSupervisor.start_link __MODULE__, :ok, name: __MODULE__
  end

  def init(:ok), do: DynamicSupervisor.init strategy: :one_for_one

  def create_queue(name) do
    DynamicSupervisor.start_child __MODULE__, {ExMq.Queue, name}
  end

  def delete_queue(pid) do
    DynamicSupervisor.terminate_child __MODULE__, pid
  end
end
