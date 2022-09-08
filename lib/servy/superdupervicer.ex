defmodule Servy.Superdupervicer do
  use Supervisor

  def start_link do
    IO.puts "Starting THE SUPERDUPERVISOR..."
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Servy.KickStarter,
      Servy.ServicesSupervicor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
