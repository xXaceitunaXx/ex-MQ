defmodule ExMq.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: :queue_registry},
      {ExMq.Queue.Supervisor, []}
    ]

    opts = [
      strategy: :one_for_one, name: ExMq.Supervisor
    ]

    Supervisor.start_link children, opts
  end
end
