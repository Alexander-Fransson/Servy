defmodule Servy.SensorServer do
  @name :sensor_server
  @refresh_interval :timer.seconds(600000)

  use GenServer

  #Client Interface

  def start_link(interval) do
    IO.puts "Starting the sensor server with #{interval} min refresh..."
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def get_sensor_data do
    GenServer.call @name, :get_sensor_data
  end

  #Server Callbacks

  def init(_state) do
    initial_state = run_tasks_to_get_sensor_data()
    schedjule_refresh
    {:ok, initial_state}
  end

  #anropar refresh var femte sekund
  defp schedjule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  def handle_info(:refresh, state) do
    IO.puts "Refreshing the cache..."
    new_state = run_tasks_to_get_sensor_data()
    schedjule_refresh
    {:noreply, new_state}
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state, state}
  end

  defp run_tasks_to_get_sensor_data do
    IO.puts "Running tasks to get sensor data..."

    task = Task.async(fn -> Servy.Tracker.get_location("Anabel") end)

    snapshots =
      ["cam-1", "cam-2","cam-3"]
      |> Enum.map(&Task.async(fn -> Servy.VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    anabels_location = Task.await(task)

    %{snaoshots: snapshots, location: anabels_location}

  end
end
