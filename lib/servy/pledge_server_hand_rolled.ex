defmodule Servy.GenericServer do

  def start(callback_module, initial_state, name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, name)
    pid
  end

  #helper functions

  def call(pid, message) do
    send pid, {:call, self(), message}
    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send pid, {:cast, message}
  end

  #lagrar pledges i katch via en oändlig loop som konstant lysnar efter pledgar
  def listen_loop(state, callback_module) do

    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state, callback_module)

      {:cast, message}  ->
        new_state = callback_module.handle_cast(message, state)
        listen_loop(new_state, callback_module)

      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop(state, callback_module)
    end
  end
end

defmodule Servy.PledgeServerHandRolled do

  @name :pledge_server_hand_rolled

  alias Servy.GenericServer

  #client stuff

  def start do
    GenericServer.start(__MODULE__,[], @name)
  end


  #skapar pledge i catchen vid kallelse
  def create_pledge(name, amount) do
    GenericServer.call @name, {:create_pledge, name, amount}
  end

  #returnar de tre senaste pledgarna
  def recent_pledges() do
    GenericServer.call @name, :recent_pledges
  end

  def total_pledged() do
    GenericServer.call @name, :total_pledges
  end

  def clear do
    GenericServer.cast @name, :clear
  end


  def handle_cast(:clear, _state) do
    []
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [{name, amount} | most_recent_pledges]
    {id, new_state}
  end

  def handle_call(:total_pledges, state) do
    total = Enum.map(state, &elem(&1,1)) |> Enum.sum
    {total, state}
  end

  def handle_call(:recent_pledges, state) do
    {state,state}
  end

  def handle_call(:total_pledges, state) do
    total = Enum.map(state, &elem(&1,1)) |> Enum.sum
  end

  #simulerar en api call
  def send_pledge_to_service(_name,_amount) do
    #CODEN FÖR ATT SJICKA SKA VARA HÄR
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

# #skapar pledgar
# alias Servy.PledgeServerHandRolled

# PledgeServerHandRolled.start()

# IO.inspect PledgeServerHandRolled.create_pledge("larry", 10)
# IO.inspect PledgeServerHandRolled.create_pledge("moe", 10)
# IO.inspect PledgeServerHandRolled.create_pledge("julius", 10)
# IO.inspect PledgeServerHandRolled.create_pledge("crasus", 10)

# PledgeServerHandRolled.clear()

# IO.inspect PledgeServerHandRolled.create_pledge("obesius", 10)
# IO.inspect PledgeServerHandRolled.create_pledge("diplodokus", 10)

# IO.inspect PledgeServerHandRolled.recent_pledges()
# IO.inspect PledgeServerHandRolled.total_pledged()
