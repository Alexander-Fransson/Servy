defmodule Servy.KickStarter do
  use GenServer

  def start_link(_arg) do
    IO.puts "Starting the kickstarter..."
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  #startar http servern och länkar den med Kickstarter servern
  def init(:ok) do
    Process.flag(:trap_exit, true) #ser till att inte kick krashar när dens länkade server gör det
    server_pid = start_server()
    {:ok, server_pid}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts "Http server exited (#{inspect reason})"
    server_pid = start_server()
    {:noreply, server_pid}
  end

  defp start_server do
    IO.puts "Starting the HTTP server..."
    port = Application.get_env(:servy, :port)
    server_pid = spawn_link(Servy.HttpServer,:start, [port])
    Process.register(server_pid, :http_server)
    server_pid
  end
end
